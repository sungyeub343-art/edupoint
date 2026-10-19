const header = document.querySelector('.site-header');
const form = document.querySelector('#consultation-form');
const status = document.querySelector('#form-status');
const year = document.querySelector('#year');
const regionDialog = document.querySelector('#region-dialog');
const regionDialogOpenButtons = document.querySelectorAll('[data-region-dialog-open]');
const regionDialogCloseButton = document.querySelector('[data-region-dialog-close]');

if (year) year.textContent = new Date().getFullYear();

const openRegionDialog = () => {
  if (regionDialog && !regionDialog.open) regionDialog.showModal();
};

regionDialogOpenButtons.forEach((button) => {
  button.addEventListener('click', openRegionDialog);
});

regionDialogCloseButton?.addEventListener('click', () => regionDialog.close());
regionDialog?.addEventListener('click', (event) => {
  const bounds = regionDialog.getBoundingClientRect();
  const isBackdropClick = event.clientX < bounds.left
    || event.clientX > bounds.right
    || event.clientY < bounds.top
    || event.clientY > bounds.bottom;
  if (isBackdropClick) regionDialog.close();
});

// 첫 방문 시 한 번만 지역 선택 창을 띄운다. 상담 신청서(#contact)로 바로 온 경우나
// 신청 완료 후 돌아온 경우에는 띄우지 않는다.
const REGION_DIALOG_SEEN_KEY = 'regionDialogSeen';
const hasSeenRegionDialog = () => {
  try { return sessionStorage.getItem(REGION_DIALOG_SEEN_KEY) === '1'; } catch { return false; }
};
const markRegionDialogSeen = () => {
  try { sessionStorage.setItem(REGION_DIALOG_SEEN_KEY, '1'); } catch { /* 저장소 차단 시 무시 */ }
};
const isDirectVisit = !window.location.hash && !window.location.search.includes('submitted=');
if (regionDialog && isDirectVisit && !hasSeenRegionDialog()) {
  markRegionDialogSeen();
  openRegionDialog();
}

const updateHeader =() => header?.classList.toggle('scrolled', window.scrollY > 24);
updateHeader();
window.addEventListener('scroll', updateHeader, { passive: true });

const params = new URLSearchParams(window.location.search);
if (status && params.get('submitted') === '1') {
  status.textContent = '상담 신청이 접수되었습니다. 확인 후 연락드리겠습니다.';
}

form?.addEventListener('submit', () => {
  const button = form.querySelector('button[type="submit"]');
  if (button) {
    button.disabled = true;
    button.textContent = '상담 신청 중...';
  }
});
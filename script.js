const header = document.querySelector('.site-header');
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

// 첫 방문 시 한 번만 지역 선택 창을 띄운다. #contact 등 해시 링크로
// 바로 온 경우에는 띄우지 않는다.
const REGION_DIALOG_SEEN_KEY = 'regionDialogSeen';
const hasSeenRegionDialog = () => {
  try { return sessionStorage.getItem(REGION_DIALOG_SEEN_KEY) === '1'; } catch { return false; }
};
const markRegionDialogSeen = () => {
  try { sessionStorage.setItem(REGION_DIALOG_SEEN_KEY, '1'); } catch { /* 저장소 차단 시 무시 */ }
};
const isDirectVisit = !window.location.hash;
if (regionDialog && isDirectVisit && !hasSeenRegionDialog()) {
  markRegionDialogSeen();
  openRegionDialog();
}

const updateHeader =() => header?.classList.toggle('scrolled', window.scrollY > 24);
updateHeader();
window.addEventListener('scroll', updateHeader, { passive: true });

const header = document.querySelector('.site-header');
const form = document.querySelector('#consultation-form');
const status = document.querySelector('#form-status');
const year = document.querySelector('#year');

if (year) year.textContent = new Date().getFullYear();

const updateHeader = () => header?.classList.toggle('scrolled', window.scrollY > 24);
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
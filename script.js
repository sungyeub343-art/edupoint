const header = document.querySelector('.site-header');
const form = document.querySelector('#consultation-form');
const status = document.querySelector('#form-status');
const year = document.querySelector('#year');

if (year) year.textContent = new Date().getFullYear();

const updateHeader = () => header?.classList.toggle('scrolled', window.scrollY > 24);
updateHeader();
window.addEventListener('scroll', updateHeader, { passive: true });

form?.addEventListener('submit', (event) => {
  event.preventDefault();
  const data = new FormData(form);
  const grade = data.get('grade');
  const area = data.get('area');
  status.textContent = `${grade} · ${area} 상담 내용이 확인되었습니다. 운영 연락처 연결 후 접수가 완료되도록 설정할 수 있습니다.`;
});
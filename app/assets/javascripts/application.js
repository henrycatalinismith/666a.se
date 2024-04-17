const burger = document.querySelector('[aria-controls="mobile-menu"]');
const menu = document.querySelector('#mobile-menu');

burger.addEventListener('click', () => {
  menu.classList.toggle('hidden');
  burger.setAttribute('aria-expanded', menu.classList.contains('hidden') ? 'false' : 'true');
});

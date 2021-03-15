$(document).on('turbolinks:load', (e) => {
  const sidenavBase = document.getElementById("sidenavBase");
  const mySidenav = document.getElementById("mySidenav");

  const openNav = () => {
    sidenavBase.style.transform = 'translateX(0)';
    mySidenav.style.border = "1px solid #e9ecef";
    sidenavBase.classList.add("in");
  }

  const closeNav = () => {
    sidenavBase.style.transform = 'translateX(-100%)';
    mySidenav.style.border = "none";
    sidenavBase.classList.remove("in");
  }

  $('#showFilters').on('click', (e) => {
    const isOpened = document.getElementById("sidenavBase").classList.contains("in");
    e.preventDefault();
    if (isOpened) {
      closeNav()
    } else {
      openNav()
    }
  });

  $('#closeFilterNav').on('click', (e) => {
    e.preventDefault();
    closeNav()
  });

  $('#resetFilters').on('click', (e) => {
    e.preventDefault();
    const $select2 = $('.select2');
    $select2.val('');
    $select2.trigger('change');
  });
});

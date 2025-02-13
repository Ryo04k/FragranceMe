document.addEventListener('turbo:load', function() {

const sidebar = document.getElementById('default-sidebar');
const items = sidebar.querySelectorAll('li');

const toggleTextVisibility = (isVisible) => {
  items.forEach(item =>{
    const text = item.querySelector('span:nth-child(2)');
    if (text) {
      text.classList.toggle('text-visible', isVisible);
    }
  });
};

const toggleSidebarWidth = (isExpanded) => {
  sidebar.classList.toggle('w-48', isExpanded);
  sidebar.classList.toggle('w-16', !isExpanded);
}

const handleMouseEnter = () => {
  toggleTextVisibility(true);
  toggleSidebarWidth(true);
};

const handleMouseLeave = () => {
  toggleTextVisibility(false);
  toggleSidebarWidth(false);
};

sidebar.addEventListener('mouseenter', handleMouseEnter);
sidebar.addEventListener('mouseleave', handleMouseLeave);
});

document.addEventListener("turbo:load", () => {
  const tabButtons = document.querySelectorAll(".tab-button");
  const subTabButtons = document.querySelectorAll(".sub-tab-button");

  // Main tab switching
  tabButtons.forEach(button => {
    button.addEventListener("click", () => {
      // Remove active class from all buttons
      tabButtons.forEach(btn => btn.classList.remove("active"));
      button.classList.add("active");

      const tab = button.dataset.tab;
      console.log(`Switched to main tab: ${tab}`);

      // You can use tab to filter or show/hide relevant sections
    });
  });

  // Sub-tab switching
  subTabButtons.forEach(button => {
    button.addEventListener("click", () => {
      subTabButtons.forEach(btn => btn.classList.remove("active"));
      button.classList.add("active");

      const subtab = button.dataset.subtab;
      console.log(`Switched to sub-tab: ${subtab}`);
      // Similarly, use subtab to filter items
    });
  });
});

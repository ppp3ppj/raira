const Session = {
  mounted() {
    const sidebarToggle = document.querySelector("[data-el-clients-list-toggle]");
    const sidePanel = document.querySelector("[data-el-side-panel]");

    if (sidebarToggle && sidePanel) {
      sidebarToggle.addEventListener("click", () => {
        sidePanel.classList.toggle("hidden");
      });
    }
  },
};

export default Session;

const Session = {
  mounted() {
    // prevent double-binding on LV patches
    if (this._wired) return;
    this._wired = true;

    const clientsBtn = this.getElement("clients-list-toggle");
    const othersBtn  = this.getElement("others-list-toggle");
    const messagesBtn = this.getElement("messages-list-toggle");

    clientsBtn && clientsBtn.addEventListener("click", () =>
      this.toggleClientsList()
    );

    othersBtn && othersBtn.addEventListener("click", () =>
      this.toggleOthersList()
    );

    messagesBtn && messagesBtn.addEventListener("click", () =>
      this.toggleMessagesList()
    );
  },

  // --- toggles --------------------------------------------------------------

  toggleClientsList(force = null) {
    return this.toggleSidePanelContent("clients-list", force);
  },

  toggleOthersList(force = null) {
    return this.toggleSidePanelContent("others-list", force);
  },

  toggleMessagesList(force = null) {
    return this.toggleSidePanelContent("messages-list", force);
  },

  toggleSidePanelContent(name, force = null) {
    const ATTR = "data-js-side-panel-content";
    const current = this.el.getAttribute(ATTR);

    // If clicking the same icon, close the panel; otherwise open/switch
    const shouldOpen = force === null ? current !== name : !!force;

    if (shouldOpen) {
      this.el.setAttribute(ATTR, name);
    } else {
      this.el.removeAttribute(ATTR);
    }
    return shouldOpen;
  },

  // --- helpers --------------------------------------------------------------

  getElement(name) {
    return this.el.querySelector(`[data-el-${name}]`);
  },
};

export default Session;

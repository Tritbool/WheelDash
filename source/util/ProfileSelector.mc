module profileSelector {
  function createPSMenu() {
    return createMenu(
      [
        AppStorage.getSetting("wheelName_p1"),
        AppStorage.getSetting("wheelName_p2"),
        AppStorage.getSetting("wheelName_p3"),
      ],
      "Profile Selection"
    );
  }
}

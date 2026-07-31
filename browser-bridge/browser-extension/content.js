(function () {
  const BTN_ID = "ytdlp-download-btn";

  function addButton() {
    if (document.getElementById(BTN_ID)) return;

    const btn = document.createElement("button");
    btn.id = BTN_ID;
    btn.textContent = "\u2B07 Download";
    btn.style.cssText = [
      "position:fixed",
      "bottom:20px",
      "right:20px",
      "z-index:999999",
      "background:#e02020",
      "color:#fff",
      "border:none",
      "padding:10px 18px",
      "border-radius:8px",
      "font-size:14px",
      "font-family:Arial,Helvetica,sans-serif",
      "font-weight:bold",
      "cursor:pointer",
      "box-shadow:0 2px 10px rgba(0,0,0,0.35)",
    ].join(";");

    btn.addEventListener("click", () => {
      const videoUrl = window.location.href;
      const link = "ytdlp://" + encodeURIComponent(videoUrl);
      window.location.href = link;
    });

    document.body.appendChild(btn);
  }

  addButton();

  // YouTube is a single-page app, so watch for navigation/DOM changes
  // and re-add the button if it gets removed.
  const observer = new MutationObserver(() => addButton());
  observer.observe(document.body, { childList: true, subtree: true });
})();

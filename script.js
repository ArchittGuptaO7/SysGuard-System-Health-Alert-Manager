/* ==========================================================
   SysGuard — Interaction Layer
   Vanilla JS only. No build step, no dependencies.
   ========================================================== */
(function () {
  'use strict';

  var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---------- Loading screen ---------- */
  window.addEventListener('load', function () {
    var loader = document.getElementById('loader');
    if (!loader) return;
    setTimeout(function () {
      loader.classList.add('hidden');
    }, reduceMotion ? 0 : 650);
  });

  /* ---------- Sticky navbar state ---------- */
  var navbar = document.getElementById('navbar');
  var backToTop = document.getElementById('backToTop');

  function onScroll() {
    var y = window.scrollY || window.pageYOffset;
    if (navbar) navbar.classList.toggle('scrolled', y > 30);
    if (backToTop) backToTop.classList.toggle('show', y > 600);
  }
  document.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  if (backToTop) {
    backToTop.addEventListener('click', function () {
      window.scrollTo({ top: 0, behavior: reduceMotion ? 'auto' : 'smooth' });
    });
  }

  /* ---------- Mobile menu ---------- */
  var menuToggle = document.getElementById('menuToggle');
  var mobileMenu = document.getElementById('mobileMenu');

  function closeMenu() {
    if (!menuToggle || !mobileMenu) return;
    menuToggle.classList.remove('open');
    mobileMenu.classList.remove('open');
    menuToggle.setAttribute('aria-expanded', 'false');
  }

  if (menuToggle && mobileMenu) {
    menuToggle.addEventListener('click', function () {
      var isOpen = mobileMenu.classList.toggle('open');
      menuToggle.classList.toggle('open', isOpen);
      menuToggle.setAttribute('aria-expanded', String(isOpen));
    });
    mobileMenu.querySelectorAll('.mobile-link').forEach(function (link) {
      link.addEventListener('click', closeMenu);
    });
  }

  /* ---------- Smooth scroll for in-page anchors ---------- */
  document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
    anchor.addEventListener('click', function (e) {
      var id = anchor.getAttribute('href');
      if (!id || id === '#') return;
      var target = document.querySelector(id);
      if (!target) return;
      e.preventDefault();
      var navHeight = navbar ? navbar.offsetHeight : 0;
      var top = target.getBoundingClientRect().top + window.pageYOffset - navHeight - 12;
      window.scrollTo({ top: top, behavior: reduceMotion ? 'auto' : 'smooth' });
      closeMenu();
    });
  });

  /* ---------- Scroll reveal ---------- */
  var revealEls = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window && !reduceMotion) {
    var io = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add('in-view');
            io.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.15, rootMargin: '0px 0px -40px 0px' }
    );
    revealEls.forEach(function (el) { io.observe(el); });
  } else {
    revealEls.forEach(function (el) { el.classList.add('in-view'); });
  }

  /* ---------- Ripple button effect ---------- */
  document.querySelectorAll('.ripple').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      var rect = btn.getBoundingClientRect();
      btn.style.setProperty('--rx', (e.clientX - rect.left) + 'px');
      btn.style.setProperty('--ry', (e.clientY - rect.top) + 'px');
      btn.classList.remove('rippling');
      // force reflow so the animation can restart
      void btn.offsetWidth;
      btn.classList.add('rippling');
    });
  });

  /* ---------- Copy button for code preview ---------- */
  var copyBtn = document.querySelector('.copy-btn');
  var codeBody = document.querySelector('.code-body');
  if (copyBtn && codeBody) {
    copyBtn.addEventListener('click', function () {
      var text = codeBody.innerText;
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(function () {
          flashCopied();
        }).catch(function () {
          flashCopied('Select & copy manually');
        });
      } else {
        flashCopied('Select & copy manually');
      }
    });
  }
  function flashCopied(msg) {
    var original = copyBtn.textContent;
    copyBtn.textContent = msg || 'Copied!';
    setTimeout(function () { copyBtn.textContent = original; }, 1600);
  }

  /* ---------- Floating particle background ---------- */
  var canvas = document.getElementById('particles');
  if (canvas && !reduceMotion) {
    var ctx = canvas.getContext('2d');
    var particles = [];
    var COUNT = window.innerWidth < 700 ? 26 : 52;
    var dpr = Math.min(window.devicePixelRatio || 1, 2);

    function resize() {
      canvas.width = window.innerWidth * dpr;
      canvas.height = window.innerHeight * dpr;
      canvas.style.width = window.innerWidth + 'px';
      canvas.style.height = window.innerHeight + 'px';
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    }

    function makeParticle() {
      return {
        x: Math.random() * window.innerWidth,
        y: Math.random() * window.innerHeight,
        r: Math.random() * 1.6 + 0.6,
        vx: (Math.random() - 0.5) * 0.12,
        vy: (Math.random() - 0.5) * 0.12,
        a: Math.random() * 0.35 + 0.08
      };
    }

    function init() {
      resize();
      particles = [];
      for (var i = 0; i < COUNT; i++) particles.push(makeParticle());
    }

    function tick() {
      ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);
      particles.forEach(function (p) {
        p.x += p.vx;
        p.y += p.vy;
        if (p.x < -10) p.x = window.innerWidth + 10;
        if (p.x > window.innerWidth + 10) p.x = -10;
        if (p.y < -10) p.y = window.innerHeight + 10;
        if (p.y > window.innerHeight + 10) p.y = -10;

        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fillStyle = 'rgba(41, 211, 152, ' + p.a + ')';
        ctx.fill();
      });
      requestAnimationFrame(tick);
    }

    init();
    tick();
    window.addEventListener('resize', function () {
      clearTimeout(window.__pResize);
      window.__pResize = setTimeout(init, 200);
    });
  }

  /* ---------- Hero terminal typewriter (real report data) ---------- */
  var typingLine = document.querySelector('.typing-line');
  // CSS animation already handles the initial fade-in; this is left
  // intentionally simple so it degrades gracefully with reduced motion.

})();

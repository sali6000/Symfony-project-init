var slider = document.getElementById("slider");
var slides = slider.getElementsByClassName("slide_slide");
var videos = slider.getElementsByClassName("slider_video");
var currentIndex = 0;

slides[currentIndex].classList.add("active");

function switchSlide(direction) {
    videos[currentIndex].load();
    slides[currentIndex].classList.remove("active");
    if (direction === "next") {
        currentIndex = (currentIndex + 1) % slides.length;
        resetTimer();
    } else {
        currentIndex = (currentIndex - 1 + slides.length) % slides.length;
        resetTimer();
    }
    slides[currentIndex].classList.add("active");
}

function nextSlide() {
    switchSlide("next");
}

function prevSlide() {
    switchSlide("prev");
}

// Attacher les événements
document.querySelector('.left-arrow').addEventListener('click', prevSlide);
document.querySelector('.right-arrow').addEventListener('click', nextSlide);

let timerId = setInterval(nextSlide, 5000);

function resetTimer() {
    clearInterval(timerId);
    timerId = setInterval(nextSlide, 5000);
}

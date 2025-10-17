// Simple client-side functionality
document.addEventListener('DOMContentLoaded', function() {
    // Update uptime
    function updateUptime() {
        const startTime = Date.now();
        setInterval(() => {
            const uptime = Date.now() - startTime;
            const hours = Math.floor(uptime / (1000 * 60 * 60));
            const minutes = Math.floor((uptime % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((uptime % (1000 * 60)) / 1000);
            
            document.getElementById('uptime').textContent = 
                `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        }, 1000);
    }

    // Simulate request counter
    let requestCount = 0;
    function incrementRequests() {
        requestCount++;
        document.getElementById('requests').textContent = requestCount;
    }

    // Initialize
    updateUptime();
    incrementRequests();

    // Increment requests every 30 seconds for demo
    setInterval(incrementRequests, 30000);

    // Add some interactivity
    const cards = document.querySelectorAll('.card');
    cards.forEach(card => {
        card.addEventListener('click', () => {
            card.style.transform = 'scale(0.98)';
            setTimeout(() => {
                card.style.transform = '';
            }, 150);
        });
    });

    console.log('🚀 Nginx Docker Web App loaded successfully!');
});
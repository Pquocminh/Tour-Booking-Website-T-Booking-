            <!-- Dynamic Content Ends Here -->
        </div> <!-- End Main Content Area -->
    </div> <!-- End App Container -->

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        // Global fix for Bootstrap modals getting trapped behind backdrops
        // due to CSS transforms or backdrop-filters on parent containers.
        document.addEventListener("DOMContentLoaded", function() {
            var modals = document.querySelectorAll('.modal');
            modals.forEach(function(modal) {
                document.body.appendChild(modal);
            });
        });
    </script>
</body>
</html>

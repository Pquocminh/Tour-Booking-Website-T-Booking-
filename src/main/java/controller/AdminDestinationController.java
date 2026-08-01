package controller;

import dao.DestinationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Destination;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDestinationController", urlPatterns = {"/admin/destinations"})
public class AdminDestinationController extends HttpServlet {

    private final DestinationDAO destinationDAO = new DestinationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("edit".equalsIgnoreCase(action) && idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Destination editDestination = destinationDAO.getDestinationById(id);
                if (editDestination != null) {
                    request.setAttribute("editDestination", editDestination);
                } else {
                    request.setAttribute("errorMessage", "Destination not found!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Destination ID!");
            }
        }

        String search = request.getParameter("search");

        // Parse pagination parameters
        int currentPage = 1;
        int pageSize = 10; // Default 10 destinations per page

        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                int parsedSize = Integer.parseInt(pageSizeParam.trim());
                if (parsedSize > 0) {
                    pageSize = parsedSize;
                }
            } catch (NumberFormatException e) {}
        }

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam.trim());
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        List<Destination> allDestinations = destinationDAO.searchDestinations(search);
        int totalDestinations = (allDestinations != null) ? allDestinations.size() : 0;
        int totalPages = (int) Math.ceil((double) totalDestinations / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalDestinations);
        List<Destination> destinations = (allDestinations != null && fromIndex < totalDestinations)
                ? allDestinations.subList(fromIndex, toIndex)
                : new java.util.ArrayList<>();

        request.setAttribute("destinations", destinations);
        request.setAttribute("searchKeyword", search);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalDestinations", totalDestinations);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("/WEB-INF/views/admin/destinations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            String destinationName = request.getParameter("destinationName");
            String province = request.getParameter("province");
            String region = request.getParameter("region");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");

            if (destinationName == null || destinationName.trim().length() < 2) {
                request.setAttribute("errorMessage", "Destination name must be at least 2 characters long!");
            } else if (destinationDAO.isDestinationNameExists(destinationName.trim(), -1)) {
                request.setAttribute("errorMessage", "Destination name '" + destinationName.trim() + "' already exists! Duplicate destination names are not allowed.");
            } else if (province == null || province.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Province is required!");
            } else if (region == null || region.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Region is required!");
            } else {
                Destination dest = new Destination();
                dest.setDestinationName(destinationName.trim());
                dest.setProvince(province.trim());
                dest.setRegion(region.trim());
                dest.setDescription(description != null ? description.trim() : "");
                dest.setImageUrl(imageUrl != null ? imageUrl.trim() : "");

                if (destinationDAO.addDestination(dest)) {
                    session.setAttribute("successMessage", "Destination created successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/destinations");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Failed to create destination. Please try again.");
                }
            }
        } else if ("update".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            String destinationName = request.getParameter("destinationName");
            String province = request.getParameter("province");
            String region = request.getParameter("region");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");

            if (destinationName == null || destinationName.trim().length() < 2) {
                request.setAttribute("errorMessage", "Destination name must be at least 2 characters long!");
                reloadEditPage(request, response, idParam);
                return;
            }
            if (province == null || province.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Province is required!");
                reloadEditPage(request, response, idParam);
                return;
            }
            if (region == null || region.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Region is required!");
                reloadEditPage(request, response, idParam);
                return;
            }

            try {
                int id = Integer.parseInt(idParam);
                if (destinationDAO.isDestinationNameExists(destinationName.trim(), id)) {
                    request.setAttribute("errorMessage", "Destination name '" + destinationName.trim() + "' already exists! Duplicate destination names are not allowed.");
                    reloadEditPage(request, response, idParam);
                    return;
                }

                Destination dest = new Destination();
                dest.setDestinationId(id);
                dest.setDestinationName(destinationName.trim());
                dest.setProvince(province.trim());
                dest.setRegion(region.trim());
                dest.setDescription(description != null ? description.trim() : "");
                dest.setImageUrl(imageUrl != null ? imageUrl.trim() : "");

                if (destinationDAO.updateDestination(dest)) {
                    session.setAttribute("successMessage", "Destination updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/destinations");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Failed to update destination. Please try again.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Destination ID!");
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            try {
                int id = Integer.parseInt(idParam);
                if (destinationDAO.isDestinationInUse(id)) {
                    session.setAttribute("errorMessage", "Cannot delete destination because it is associated with existing tours!");
                } else if (destinationDAO.deleteDestination(id)) {
                    session.setAttribute("successMessage", "Destination deleted successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to delete destination!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid Destination ID!");
            }
            response.sendRedirect(request.getContextPath() + "/admin/destinations");
            return;
        }

        String search = request.getParameter("search");
        List<Destination> destinations = destinationDAO.searchDestinations(search);
        request.setAttribute("destinations", destinations);
        request.setAttribute("searchKeyword", search);
        request.getRequestDispatcher("/WEB-INF/views/admin/destinations.jsp").forward(request, response);
    }

    private void reloadEditPage(HttpServletRequest request, HttpServletResponse response, String idParam)
            throws ServletException, IOException {
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Destination editDestination = destinationDAO.getDestinationById(id);
                if (editDestination != null) {
                    request.setAttribute("editDestination", editDestination);
                }
            } catch (NumberFormatException e) {}
        }
        String search = request.getParameter("search");
        List<Destination> destinations = destinationDAO.searchDestinations(search);
        request.setAttribute("destinations", destinations);
        request.setAttribute("searchKeyword", search);
        request.getRequestDispatcher("/WEB-INF/views/admin/destinations.jsp").forward(request, response);
    }
}

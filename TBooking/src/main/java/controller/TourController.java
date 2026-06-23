package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Tour;
import service.TourService;

@WebServlet(name = "TourController", urlPatterns = {"/tours"})
public class TourController extends HttpServlet {
    private final TourService tourService = new TourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Tour> tours = tourService.getAvailableTours();
        request.setAttribute("tours", tours);
        request.getRequestDispatcher("/WEB-INF/views/guest/tours.jsp").forward(request, response);
    }
}

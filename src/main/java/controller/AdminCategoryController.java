package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;
import service.CategoryService;

@WebServlet(name = "AdminCategoryController", urlPatterns = {"/admin/categories"})
public class AdminCategoryController extends HttpServlet {
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("edit".equalsIgnoreCase(action) && idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Category editCategory = categoryService.getCategoryById(id);
                if (editCategory != null) {
                    request.setAttribute("editCategory", editCategory);
                } else {
                    request.setAttribute("errorMessage", "Category not found!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Category ID!");
            }
        }

        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("create".equalsIgnoreCase(action)) {
            String categoryName = request.getParameter("categoryName");
            String description = request.getParameter("description");
            if (categoryName == null || categoryName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Category name is required!");
            } else {
                Category cat = new Category();
                cat.setCategoryName(categoryName);
                cat.setDescription(description);
                if (categoryService.addCategory(cat)) {
                    request.getSession().setAttribute("successMessage", "Category created successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Failed to create category. Please try again.");
                }
            }
        } else if ("update".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            String categoryName = request.getParameter("categoryName");
            String description = request.getParameter("description");

            if (categoryName == null || categoryName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Category name is required!");
                reloadPageWithEditCategory(request, response, idParam);
                return;
            }

            try {
                int id = Integer.parseInt(idParam);
                Category category = new Category(id, categoryName, description);
                boolean success = categoryService.updateCategory(category);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Category updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Failed to update category. Please try again.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Category ID!");
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            try {
                int id = Integer.parseInt(idParam);
                if (categoryService.deleteCategory(id)) {
                    request.getSession().setAttribute("successMessage", "Category deleted successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete category. It might contain tours!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid Category ID!");
            }
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-categories.jsp").forward(request, response);
    }

    private void reloadPageWithEditCategory(HttpServletRequest request, HttpServletResponse response, String idParam) 
            throws ServletException, IOException {
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Category editCategory = categoryService.getCategoryById(id);
                if (editCategory != null) {
                    request.setAttribute("editCategory", editCategory);
                }
            } catch (NumberFormatException e) {}
        }
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-categories.jsp").forward(request, response);
    }
}

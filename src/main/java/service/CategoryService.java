package service;

import dao.CategoryDAO;
import model.Category;
import java.util.List;

public class CategoryService {
    private final CategoryDAO categoryDAO = new CategoryDAO();
    
    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }
    
    public Category getCategoryById(int categoryId) {
        return categoryDAO.getCategoryById(categoryId);
    }
    
    public boolean updateCategory(Category category) {
        if (category == null || category.getCategoryName() == null || category.getCategoryName().trim().isEmpty()) {
            return false;
        }
        // Trim category properties
        category.setCategoryName(category.getCategoryName().trim());
        if (category.getDescription() != null) {
            category.setDescription(category.getDescription().trim());
        }
        return categoryDAO.updateCategory(category);
    }
}

package service;

import dao.SystemSettingDAO;
import model.SystemSetting;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SystemSettingService {
    private final SystemSettingDAO dao = new SystemSettingDAO();

    public List<SystemSetting> getAllSettings() throws SQLException {
        return dao.getAllSettings();
    }

    public Map<String, String> getSettingsMap() throws SQLException {
        List<SystemSetting> list = dao.getAllSettings();
        Map<String, String> map = new HashMap<>();
        for (SystemSetting s : list) {
            map.put(s.getSettingKey(), s.getSettingValue());
        }
        return map;
    }

    public boolean updateSetting(String key, String value) throws SQLException {
        return dao.updateSetting(key, value);
    }

    public boolean updateSettings(Map<String, String> newSettings) throws SQLException {
        boolean success = true;
        for (Map.Entry<String, String> entry : newSettings.entrySet()) {
            if (!dao.updateSetting(entry.getKey(), entry.getValue())) {
                success = false;
            }
        }
        return success;
    }
}

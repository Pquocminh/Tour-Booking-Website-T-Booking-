package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import model.Account;
import service.AccountService;

@WebServlet(name = "LoginGoogleController", urlPatterns = {"/login-google"})
public class LoginGoogleController extends HttpServlet {
    private final AccountService accountService = new AccountService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idToken = request.getParameter("credential");
        if (idToken == null || idToken.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login?error=Missing+Google+Credential");
            return;
        }

        GoogleUser googleUser = verifyGoogleToken(idToken);
        if (googleUser != null && "true".equalsIgnoreCase(googleUser.email_verified)) {
            Account acc = accountService.loginOrCreateGoogleAccount(googleUser.email, googleUser.name);
            if (acc != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", acc);
                response.sendRedirect(request.getContextPath() + "/tours");
                return;
            }
        }

        request.setAttribute("error", "Google authentication failed, or account is suspended!");
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    private GoogleUser verifyGoogleToken(String idToken) {
        try {
            String urlString = "https://oauth2.googleapis.com/tokeninfo?id_token=" + idToken;
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                InputStream is = conn.getInputStream();
                BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
                reader.close();

                Gson gson = new Gson();
                return gson.fromJson(sb.toString(), GoogleUser.class);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static class GoogleUser {
        String email;
        String name;
        String sub;
        String email_verified;
    }
}

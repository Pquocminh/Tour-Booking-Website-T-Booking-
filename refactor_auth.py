import os
import re

files = [
    "LoginController.java",
    "LogoutController.java",
    "RegisterController.java",
    "LoginGoogleController.java",
    "ForgotPasswordController.java",
    "VerifyOtpController.java",
    "ResetPasswordController.java"
]

base_dir = "src/main/java/controller/"

all_imports = set()
class_fields = set()
methods_get = []
methods_post = []
helper_methods = []

for file in files:
    with open(base_dir + file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract imports
    imports = re.findall(r'^import\s+.*?;', content, re.MULTILINE)
    for imp in imports:
        if "jakarta.servlet.annotation.WebServlet" not in imp:
            all_imports.add(imp)

    # Extract class body
    body_match = re.search(r'public class \w+ extends HttpServlet \{([\s\S]*)\}', content)
    if not body_match:
        continue
    body = body_match.group(1)

    # Split body into methods and fields
    # A simple regex to find top-level fields (heuristic: ends with ;)
    # We will just manually add the common fields
    
    path = "/" + file.replace('Controller.java', '').replace('LoginGoogle', 'login-google').replace('ForgotPassword', 'forgot-password').replace('VerifyOtp', 'verify-otp').replace('ResetPassword', 'reset-password').lower()
    
    if path == "/login-google":
        path = "/login-google" # keep as is
    elif path == "/forgot-password":
        path = "/forgot-password"
    elif path == "/verify-otp":
        path = "/verify-otp"
    elif path == "/reset-password":
        path = "/reset-password"

    # We can just extract doGet and doPost
    doget_match = re.search(r'protected void doGet\(HttpServletRequest request, HttpServletResponse response\)\s+throws ServletException, IOException \{([\s\S]*?)\n    }(?=\s+@|\s+protected|\s+public|\s+private|$)', body)
    if doget_match:
        methods_get.append((path, doget_match.group(1)))

    dopost_match = re.search(r'protected void doPost\(HttpServletRequest request, HttpServletResponse response\)\s+throws ServletException, IOException \{([\s\S]*?)\n    }(?=\s+@|\s+protected|\s+public|\s+private|$)', body)
    if dopost_match:
        methods_post.append((path, dopost_match.group(1)))

    # Find helper methods (e.g. generateOTP, sendOTPEmail)
    helpers = re.findall(r'private [^\(]+\([^\)]+\)\s*\{[\s\S]*?\n    }(?=\s+@|\s+protected|\s+public|\s+private|$)', body)
    for helper in helpers:
        helper_methods.append(helper)

# Generate AuthController.java
out = "package controller;\n\n"
for imp in sorted(all_imports):
    out += imp + "\n"
out += "import jakarta.servlet.annotation.WebServlet;\n\n"

url_patterns = '", "'.join(["/login", "/logout", "/register", "/login-google", "/forgot-password", "/verify-otp", "/reset-password"])
out += f'@WebServlet(name = "AuthController", urlPatterns = {{"{url_patterns}"}})\n'
out += "public class AuthController extends HttpServlet {\n"
out += "    private final service.AccountService accountService = new service.AccountService();\n"
out += "    private final service.SystemSettingService settingService = new service.SystemSettingService();\n\n"

# doGet
out += "    @Override\n"
out += "    protected void doGet(HttpServletRequest request, HttpServletResponse response)\n"
out += "            throws ServletException, IOException {\n"
out += "        String path = request.getServletPath();\n"
out += "        switch (path) {\n"
for path, code in methods_get:
    method_name = "handle" + "".join(word.capitalize() for word in path.strip("/").split("-")) + "Get"
    out += f'            case "{path}":\n'
    out += f'                {method_name}(request, response);\n'
    out += f'                break;\n'
out += "            default:\n"
out += "                response.sendError(HttpServletResponse.SC_NOT_FOUND);\n"
out += "        }\n"
out += "    }\n\n"

# doPost
out += "    @Override\n"
out += "    protected void doPost(HttpServletRequest request, HttpServletResponse response)\n"
out += "            throws ServletException, IOException {\n"
out += "        String path = request.getServletPath();\n"
out += "        switch (path) {\n"
for path, code in methods_post:
    method_name = "handle" + "".join(word.capitalize() for word in path.strip("/").split("-")) + "Post"
    out += f'            case "{path}":\n'
    out += f'                {method_name}(request, response);\n'
    out += f'                break;\n'
out += "            default:\n"
out += "                response.sendError(HttpServletResponse.SC_NOT_FOUND);\n"
out += "        }\n"
out += "    }\n\n"

# Add the separated get methods
for path, code in methods_get:
    method_name = "handle" + "".join(word.capitalize() for word in path.strip("/").split("-")) + "Get"
    out += f"    private void {method_name}(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {{"
    out += code + "\n    }\n\n"

# Add the separated post methods
for path, code in methods_post:
    method_name = "handle" + "".join(word.capitalize() for word in path.strip("/").split("-")) + "Post"
    out += f"    private void {method_name}(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {{"
    out += code + "\n    }\n\n"

# Add helpers
for helper in helper_methods:
    out += "    " + helper + "\n    }\n\n"

out += "}\n"

with open(base_dir + "AuthController.java", "w", encoding="utf-8") as f:
    f.write(out)

for file in files:
    os.remove(base_dir + file)

print("AuthController created and old controllers deleted.")

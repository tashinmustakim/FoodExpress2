import os
import sys
import html
from reportlab.lib.pagesizes import letter, A4
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.pdfgen import canvas

# Define custom canvas for Page X of Y and running headers
class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super().showPage()
        super().save()

    def draw_page_decorations(self, page_count):
        self.saveState()
        self.setFont("Helvetica-Bold", 8)
        self.setFillColor(colors.HexColor("#475569"))

        # Top Header (Only on page 2 and later)
        if self._pageNumber > 1:
            self.drawString(54, 842 - 36, "FoodXpress — Complete Web Controllers Architecture & Code Guide")
            self.setFont("Helvetica", 8)
            self.drawRightString(595.27 - 54, 842 - 36, "Java EE Servlets")
            self.setStrokeColor(colors.HexColor("#cbd5e1"))
            self.setLineWidth(0.5)
            self.line(54, 842 - 42, 595.27 - 54, 842 - 42)

        # Bottom Footer (Every page)
        self.setStrokeColor(colors.HexColor("#cbd5e1"))
        self.setLineWidth(0.5)
        self.line(54, 45, 595.27 - 54, 45)

        self.setFont("Helvetica", 8)
        self.setFillColor(colors.HexColor("#64748b"))
        self.drawString(54, 32, "FoodXpress Online Food Delivery System — Comprehensive Technical Documentation")
        page_text = f"Page {self._pageNumber} of {page_count}"
        self.drawRightString(595.27 - 54, 32, page_text)
        self.restoreState()

def clean_text_for_pdf(text):
    """Escape HTML entities for ReportLab XML paragraph engine."""
    return html.escape(text).replace("\t", "    ")

def get_controller_explanations():
    return {
        "UserServlet.java": {
            "url": "/user",
            "access": "Public / All Users",
            "purpose": "User Authentication, Account Registration, and Session Management Controller.",
            "description": (
                "UserServlet is the primary gateway for identity management in FoodXpress. "
                "It handles user registration, password hashing via BCrypt, credential validation upon login, "
                "session initialization (storing user entity and assigned role), and secure session destruction upon logout."
            ),
            "methods": [
                ("doGet()", "Processes logout requests by invalidating the HTTP Session and forwarding users to login/home pages."),
                ("doPost()", "Handles form submissions for login (`action=login`) and registration (`action=register`). Checks credentials, hashes passwords, sets session attributes (`loggedUser`, `userRole`), and executes role-based redirection.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Password Security: Utilizes BCrypt hashing before persisting user records into MySQL via `UserDAO`.\n"
                "• Role-Based Routing: If an authenticated user's role is 'admin', they are automatically redirected to `/admin/dashboard`. Customers are forwarded to `/jsp/customer/home.jsp`.\n"
                "• Session Management: Stores user state in `HttpSession.setAttribute(\"loggedUser\", user)` for global session persistence across requests."
            )
        },
        "RestaurantServlet.java": {
            "url": "/restaurant",
            "access": "Customer / Public",
            "purpose": "Restaurant Listing, Search, and Detailed Profile Discovery Controller.",
            "description": (
                "RestaurantServlet provides restaurant discovery features for customers. "
                "It retrieves all active Bangladeshi restaurants (e.g., Kacchi Bhai, Sultan's Dine, Star Kabab, Nanna Biryani, Takeout Bangladesh) "
                "and fetches individual restaurant menus and customer reviews."
            ),
            "methods": [
                ("doGet()", "Handles `action=list` to fetch all restaurants or `action=details` to display a specific restaurant along with its dishes and customer ratings."),
                ("doPost()", "Delegates search queries and restaurant filter actions to `doGet()`.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Data Aggregation: Combines `RestaurantDAO` (restaurant profiles), `MenuDAO` (associated menu dishes), and `ReviewDAO` (customer star ratings and reviews).\n"
                "• Request Attributes: Prepares `${restaurants}`, `${restaurant}`, `${menuItems}`, and `${reviews}` for consumption by JSP rendering templates (`restaurantList.jsp`, `restaurantDetails.jsp`)."
            )
        },
        "CartServlet.java": {
            "url": "/cart",
            "access": "Customer",
            "purpose": "Shopping Cart Session State & Price Calculation Engine.",
            "description": (
                "CartServlet manages the customer's in-memory shopping cart stored within their active `HttpSession`. "
                "It allows customers to add dishes, adjust quantities, remove items, and view price calculations in Bangladeshi Taka (৳)."
            ),
            "methods": [
                ("doGet()", "Displays current cart contents (`cart.jsp`) with calculated subtotal, delivery fee (৳20), platform fee (৳5), and tax (3%)."),
                ("doPost()", "Handles `action=add`, `action=update`, `action=delete`, and `action=clear`. Mutates the `Cart` object stored in the HTTP Session.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• In-Memory Cart Management: Instantiates or fetches a `Cart` object from `session.getAttribute(\"cart\")`.\n"
                "• Currency Consistency: Computes item subtotals and grand total formatted in Taka (৳).\n"
                "• Synchronization: Ensures cart updates dynamically persist across page navigations before final checkout."
            )
        },
        "CheckoutServlet.java": {
            "url": "/checkout",
            "access": "Customer",
            "purpose": "Order Placement, Address Assignment, and Transaction Persistence Controller.",
            "description": (
                "CheckoutServlet transitions active shopping cart items into an official persistent Order record in MySQL. "
                "It validates user authentication, verifies cart contents, assigns delivery addresses, creates order items, and flushes the active cart."
            ),
            "methods": [
                ("doGet()", "Renders order confirmation and address selection screen (`checkout.jsp`)."),
                ("doPost()", "Validates session, creates `Order` entity with status `PENDING`, saves order via `OrderDAO.createOrder()`, persists item details via `OrderItemDAO`, clears cart, and redirects to `/orderSuccess`.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Transactional Flow: Inserts parent record in `orders` table and child records in `order_items` table.\n"
                "• Address & Payment Binding: Associates selected delivery address ID and chosen payment method (bKash/Nagad/COD/Card).\n"
                "• Session Clearance: Resets active session cart upon successful order creation to prevent duplicate submission."
            )
        },
        "OrderHistoryServlet.java": {
            "url": "/orderHistory",
            "access": "Customer",
            "purpose": "Customer Order History Timeline & Tracking Controller.",
            "description": (
                "OrderHistoryServlet retrieves and displays past orders placed by the currently logged-in customer. "
                "It presents order statuses (`PENDING`, `PREPARING`, `OUT_FOR_DELIVERY`, `DELIVERED`, `CANCELLED`) with itemized details."
            ),
            "methods": [
                ("doGet()", "Extracts `userId` from session, queries `OrderDAO.getOrdersByUserId(userId)`, attaches order list to request scope, and forwards to `orderHistory.jsp`."),
                ("doPost()", "Delegates processing to `doGet()`.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Security Isolation: Restricts query results strictly to the logged-in customer's `userId`.\n"
                "• Status Mapping: Provides real-time order tracking statuses updated by system administrators."
            )
        },
        "ReviewServlet.java": {
            "url": "/review",
            "access": "Customer",
            "purpose": "Customer Rating (1-5 Stars) & Feedback Submission Controller.",
            "description": (
                "ReviewServlet handles customer rating and review comments for Bangladeshi restaurants. "
                "Upon review submission, it triggers an automated recalculation of the restaurant's overall average star rating in the database."
            ),
            "methods": [
                ("doGet()", "Redirects to restaurant details view."),
                ("doPost()", "Validates logged-in customer session, reads `restaurantId`, `rating` (1-5), and `comment`. Persists review via `ReviewDAO.addReview()` and updates restaurant average rating.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Automated Recalculation: Calls `ReviewDAO.updateRestaurantAverageRating(restaurantId)` to immediately compute and store updated average star ratings.\n"
                "• Input Validation: Ensures ratings are bounded between 1 and 5 stars and comments are properly sanitized."
            )
        },
        "AddressServlet.java": {
            "url": "/address",
            "access": "Customer",
            "purpose": "Customer Delivery Address CRUD Controller.",
            "description": (
                "AddressServlet manages customer delivery address entries (street, city, zip code, landmark). "
                "It enables users to save multiple delivery locations for quick selection during checkout."
            ),
            "methods": [
                ("doGet()", "Lists existing saved addresses for logged-in user or renders address creation form."),
                ("doPost()", "Handles adding (`action=add`), editing (`action=edit`), or deleting (`action=delete`) address records via `AddressDAO`.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• User Binding: Links every saved address directly to the authenticated customer's `userId`.\n"
                "• Address Reusability: Allows saved addresses to be referenced seamlessly during order checkout."
            )
        },
        "AdminDashboardServlet.java": {
            "url": "/admin/dashboard",
            "access": "Admin Only",
            "purpose": "Administrator Analytics & Platform Summary Controller.",
            "description": (
                "AdminDashboardServlet serves as the executive summary dashboard for FoodXpress administrators. "
                "It aggregates real-time metrics across total platform revenue (৳), total completed orders, active Bangladeshi restaurants, and registered users."
            ),
            "methods": [
                ("doGet()", "Executes database aggregations using `OrderDAO`, `RestaurantDAO`, and `UserDAO`. Attaches metrics (`totalRevenue`, `totalOrders`, `activeRestaurants`, `totalUsers`) to request scope and forwards to `/jsp/admin/dashboard.jsp`."),
                ("doPost()", "Delegates processing to `doGet()`.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Analytics Aggregation: Calculates live sum of non-cancelled orders in Taka (৳).\n"
                "• Access Control: Protected by admin role check (`session.getAttribute(\"userRole\") == \"admin\"`)."
            )
        },
        "AdminOrderServlet.java": {
            "url": "/admin/orders",
            "access": "Admin Only",
            "purpose": "Administrator Order Dispatching & Live Status Management Controller.",
            "description": (
                "AdminOrderServlet allows administrators to oversee all platform orders across all restaurants and users, "
                "allowing live status updates (`PENDING` ➔ `PREPARING` ➔ `OUT_FOR_DELIVERY` ➔ `DELIVERED`)."
            ),
            "methods": [
                ("doGet()", "Fetches all system orders via `OrderDAO.getAllOrders()` and displays them on `orderListAdmin.jsp`."),
                ("doPost()", "Accepts `orderId` and `status`, updates MySQL order status via `OrderDAO.updateOrderStatus()`, and redirects back to order list.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Live Status Dispatching: Enables real-time workflow tracking from kitchen prep to customer delivery.\n"
                "• Cross-Platform Visibility: Provides complete administrative audit trail for all customer orders."
            )
        },
        "AdminUserServlet.java": {
            "url": "/admin/users",
            "access": "Admin Only",
            "purpose": "User Account Management & Role Elevation Controller.",
            "description": (
                "AdminUserServlet provides administrative governance over user accounts. "
                "Admins can view registered users, elevate customer roles to administrator or delivery staff, or remove accounts."
            ),
            "methods": [
                ("doGet()", "Retrieves all registered user accounts from `UserDAO` and forwards to `userListAdmin.jsp`."),
                ("doPost()", "Processes role elevation (`action=changeRole`) or user deletion (`action=delete`).")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Role Escalation: Enables dynamic permission updates (`customer`, `admin`, `delivery`).\n"
                "• User Governance: Protects system integrity by allowing administrative account management."
            )
        },
        "AdminReviewServlet.java": {
            "url": "/admin/reviews",
            "access": "Admin Only",
            "purpose": "Customer Feedback & Review Moderation Controller.",
            "description": (
                "AdminReviewServlet allows administrators to monitor customer ratings and reviews across all Bangladeshi restaurants, "
                "enabling feedback moderation and deleting inappropriate reviews."
            ),
            "methods": [
                ("doGet()", "Fetches all platform reviews via `ReviewDAO.getAllReviews()` and renders `reviewListAdmin.jsp`."),
                ("doPost()", "Deletes specified review entries (`action=delete`) and triggers restaurant rating recalculations.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Quality Control: Maintains review integrity across all platform restaurants.\n"
                "• Automatic Sync: Recalculates restaurant star averages whenever a review is moderated."
            )
        },
        "AdminRestaurantServlet.java": {
            "url": "/admin/restaurants",
            "access": "Admin Only",
            "purpose": "Bangladeshi Restaurant CRUD Management Controller.",
            "description": (
                "AdminRestaurantServlet provides full administrative CRUD functionality for Bangladeshi restaurants. "
                "Admins can register new restaurants (name, cuisine, location, contact, image URL), edit profiles, or deactivate listings."
            ),
            "methods": [
                ("doGet()", "Lists all restaurants for administrative management or renders edit forms."),
                ("doPost()", "Handles adding (`action=add`), editing (`action=edit`), or deleting (`action=delete`) restaurant records via `RestaurantDAO`.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Profile Management: Controls restaurant visibility, address details in Dhaka, and image assets.\n"
                "• Database Synchronization: Directly updates `restaurants` table in MySQL."
            )
        },
        "AdminMenuServlet.java": {
            "url": "/admin/menu",
            "access": "Admin Only",
            "purpose": "Restaurant Menu Items & Dish Pricing (৳) CRUD Controller.",
            "description": (
                "AdminMenuServlet gives admins control over dish catalogs for each restaurant. "
                "Admins can add new dishes (Kacchi Biryani, Morog Polao, Grill Chicken), set prices in Taka (৳), update descriptions, and toggle dish availability."
            ),
            "methods": [
                ("doGet()", "Fetches menu items for a specific restaurant ID or loads dish edit form."),
                ("doPost()", "Processes dish creation (`action=add`), updating (`action=edit`), deletion (`action=delete`), or availability toggling (`action=toggleAvailability`).")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Currency Management: Persists dish pricing in Bangladeshi Taka (৳).\n"
                "• Availability Toggling: Enables instant stock status updates for menu items."
            )
        },
        "MenuServlet.java": {
            "url": "/menu",
            "access": "Public / Customer",
            "purpose": "Menu Item Query & Search Controller.",
            "description": (
                "MenuServlet provides customer-facing menu item lookup and search queries across dishes and cuisines."
            ),
            "methods": [
                ("doGet()", "Queries dishes by restaurant ID or search keyword using `MenuDAO` and forwards results to `menuList.jsp`."),
                ("doPost()", "Delegates search submissions to `doGet()`.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Filtered Lookup: Supports searching dishes by name, category, or restaurant.\n"
                "• Real-Time Display: Attaches dish collections to `${menuItems}` for JSP rendering."
            )
        },
        "OrderSummaryServlet.java": {
            "url": "/orderSummary",
            "access": "Customer",
            "purpose": "Pre-Checkout Itemized Invoice Review Controller.",
            "description": (
                "OrderSummaryServlet renders a pre-checkout itemized invoice breakdown, displaying selected items, subtotal, tax, delivery fees, and total in Taka (৳)."
            ),
            "methods": [
                ("doGet()", "Reads active session cart, computes tax/delivery fees, attaches summary details to request scope, and forwards to `orderSummary.jsp`."),
                ("doPost()", "Delegates to `doGet()`.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Invoice Verification: Allows customers to verify order breakdown before choosing address and payment method."
            )
        },
        "PaymentServlet.java": {
            "url": "/payment",
            "access": "Customer",
            "purpose": "Payment Processing & Gateway Simulation Controller.",
            "description": (
                "PaymentServlet simulates payment processing for bKash, Nagad, Credit/Debit Cards, and Cash on Delivery (COD)."
            ),
            "methods": [
                ("doGet()", "Renders payment selection interface (`payment.jsp`)."),
                ("doPost()", "Validates payment details, updates order payment status to `PAID` or `PENDING_COD`, and forwards to order confirmation.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Multi-Channel Support: Handles Bangladeshi mobile financial services (bKash/Nagad) alongside traditional COD."
            )
        },
        "OrderSuccessServlet.java": {
            "url": "/orderSuccess",
            "access": "Customer",
            "purpose": "Order Confirmation & Final Receipt Controller.",
            "description": (
                "OrderSuccessServlet displays the final order confirmation receipt after successful checkout."
            ),
            "methods": [
                ("doGet()", "Accepts `orderId` parameter, fetches order details via `OrderDAO.getOrderById()`, and renders `orderSuccess.jsp`."),
                ("doPost()", "Delegates to `doGet()`.")
            ],
            "details": (
                "Key Implementation Highlights:\n"
                "• Receipt Generation: Displays order ID, estimated delivery time, and final bill breakdown in Taka (৳)."
            )
        }
    }

def main():
    print("Starting PDF generation script...")
    
    controllers_dir = r"c:\Users\user\Desktop\foodexpress\FoodXpress\FoodApp\src\main\java\com\app\controllers"
    output_pdf_path = r"c:\Users\user\Desktop\foodexpress\FoodXpress\FoodApp\FoodXpress_Controllers_Complete_Guide.pdf"
    desktop_pdf_path = r"c:\Users\user\Desktop\FoodXpress_Controllers_Complete_Guide.pdf"
    
    controller_explanations = get_controller_explanations()
    
    # Page setup
    doc = SimpleDocTemplate(
        output_pdf_path,
        pagesize=A4,
        leftMargin=54,
        rightMargin=54,
        topMargin=54,
        bottomMargin=54
    )
    
    styles = getSampleStyleSheet()
    
    # Custom Palette
    c_primary = colors.HexColor("#0f172a")    # Slate 900
    c_secondary = colors.HexColor("#1e293b")  # Slate 800
    c_accent = colors.HexColor("#2563eb")     # Blue 600
    c_bg_code = colors.HexColor("#f8fafc")    # Slate 50
    c_border_code = colors.HexColor("#cbd5e1")# Slate 300
    c_text_dark = colors.HexColor("#1e293b")  # Slate 800
    c_text_muted = colors.HexColor("#64748b") # Slate 500
    
    # Custom Typography Styles
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=24,
        leading=28,
        textColor=c_primary,
        spaceAfter=6
    )
    
    subtitle_style = ParagraphStyle(
        'DocSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=12,
        leading=16,
        textColor=c_accent,
        spaceAfter=15
    )
    
    h1_style = ParagraphStyle(
        'Heading1_Custom',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=16,
        leading=20,
        textColor=c_primary,
        spaceBefore=14,
        spaceAfter=8,
        keepWithNext=True
    )
    
    h2_style = ParagraphStyle(
        'Heading2_Custom',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=12,
        leading=16,
        textColor=c_secondary,
        spaceBefore=10,
        spaceAfter=6,
        keepWithNext=True
    )
    
    body_style = ParagraphStyle(
        'Body_Custom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=14,
        textColor=c_text_dark,
        spaceAfter=8
    )

    meta_style = ParagraphStyle(
        'Meta_Custom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9,
        leading=13,
        textColor=c_text_muted,
        spaceAfter=6
    )
    
    code_style = ParagraphStyle(
        'CodeStyle',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=7.5,
        leading=9.5,
        textColor=colors.HexColor("#0f172a")
    )
    
    story = []
    
    # -------------------------------------------------------------------------
    # COVER / TITLE HEADER BANNER
    # -------------------------------------------------------------------------
    story.append(Paragraph("FoodXpress Web Application", title_style))
    story.append(Paragraph("Complete Web Controllers Architecture & Code Explanation Guide", subtitle_style))
    story.append(HRFlowable(width="100%", thickness=2, color=c_accent, spaceAfter=15))
    
    overview_text = (
        "<b>Executive Summary & MVC Architecture Overview:</b><br/>"
        "In the <b>FoodXpress</b> Java EE web application, <b>Controllers (Servlets)</b> act as the central request handlers "
        "and traffic orchestrators. Extending <code>HttpServlet</code>, these 17 controllers receive HTTP GET and POST requests from the client browser, "
        "interact with the MySQL database via the <b>Data Access Object (DAO)</b> layer, update HTTP Session and Request scopes, "
        "and forward user control to JSP view templates.<br/><br/>"
        "This document provides a comprehensive technical breakdown of all <b>17 Controller Servlets</b> in the system, "
        "combining high-level architectural responsibilities, URL mappings, HTTP method flows, and exact Java source code."
    )
    story.append(Paragraph(overview_text, body_style))
    story.append(Spacer(1, 10))
    
    # -------------------------------------------------------------------------
    # SUMMARY TABLE OF ALL 17 CONTROLLERS
    # -------------------------------------------------------------------------
    story.append(Paragraph("📋 Controller Summary Matrix (17 Servlets)", h1_style))
    
    table_data = [
        [Paragraph("<b>#</b>", meta_style), Paragraph("<b>Servlet Class</b>", meta_style), Paragraph("<b>URL Pattern</b>", meta_style), Paragraph("<b>Role / Access</b>", meta_style), Paragraph("<b>Primary Function</b>", meta_style)]
    ]
    
    controller_order = [
        "UserServlet.java", "RestaurantServlet.java", "CartServlet.java", "CheckoutServlet.java",
        "OrderHistoryServlet.java", "ReviewServlet.java", "AddressServlet.java", "AdminDashboardServlet.java",
        "AdminOrderServlet.java", "AdminUserServlet.java", "AdminReviewServlet.java", "AdminRestaurantServlet.java",
        "AdminMenuServlet.java", "MenuServlet.java", "OrderSummaryServlet.java", "PaymentServlet.java", "OrderSuccessServlet.java"
    ]
    
    for idx, fname in enumerate(controller_order, 1):
        info = controller_explanations.get(fname, {})
        url_pat = info.get("url", "N/A")
        access = info.get("access", "N/A")
        purpose = info.get("purpose", "N/A")
        
        table_data.append([
            Paragraph(f"<b>{idx}</b>", body_style),
            Paragraph(f"<code>{fname.replace('.java', '')}</code>", body_style),
            Paragraph(f"<code>{url_pat}</code>", body_style),
            Paragraph(access, body_style),
            Paragraph(purpose, body_style)
        ])
        
    summary_table = Table(table_data, colWidths=[20, 110, 80, 95, 182])
    summary_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#f1f5f9")),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.HexColor("#0f172a")),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#cbd5e1")),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
    ]))
    
    story.append(summary_table)
    story.append(Spacer(1, 15))
    story.append(PageBreak())
    
    # -------------------------------------------------------------------------
    # DETAILED CONTROLLER BREAKDOWN & SOURCE CODE
    # -------------------------------------------------------------------------
    story.append(Paragraph("📂 Deep-Dive Controller Analysis & Source Code", h1_style))
    story.append(HRFlowable(width="100%", thickness=1, color=c_border_code, spaceAfter=12))
    
    for idx, fname in enumerate(controller_order, 1):
        file_path = os.path.join(controllers_dir, fname)
        info = controller_explanations.get(fname, {})
        
        # Read source code
        code_text = ""
        if os.path.exists(file_path):
            with open(file_path, "r", encoding="utf-8") as f:
                code_text = f.read()
        else:
            code_text = f"// File not found: {file_path}"
            
        # Build Controller Section
        story.append(Paragraph(f"{idx}. {fname} (URL: <code>{info.get('url', '')}</code>)", h2_style))
        
        meta_info = f"<b>Role / Access Level:</b> {info.get('access', 'N/A')}<br/>" \
                    f"<b>Primary Purpose:</b> {info.get('purpose', 'N/A')}"
        story.append(Paragraph(meta_info, meta_style))
        story.append(Spacer(1, 4))
        
        # Description & Method Breakdown
        story.append(Paragraph(f"<b>Architectural Overview:</b> {info.get('description', '')}", body_style))
        
        methods_html = "<b>HTTP Methods & Flow Breakdown:</b><br/>"
        for m_name, m_desc in info.get("methods", []):
            methods_html += f"• <b><code>{m_name}</code></b>: {m_desc}<br/>"
        story.append(Paragraph(methods_html, body_style))
        
        details_text = info.get("details", "").replace("\n", "<br/>")
        if details_text:
            story.append(Paragraph(details_text, body_style))
            
        story.append(Spacer(1, 6))
        story.append(Paragraph(f"<b>Source Code (<code>{fname}</code>):</b>", meta_style))
        
        # Code block output using individual code paragraphs so ReportLab can page-break across pages
        escaped_code = clean_text_for_pdf(code_text)
        lines = escaped_code.split("\n")
        
        # We process lines into preformatted chunk paragraphs
        code_chunks = []
        chunk_lines = []
        chunk_size = 35 # lines per paragraph block to allow smooth splitting
        
        for l_idx, line in enumerate(lines, 1):
            # preserve leading indentation spaces as non-breaking spaces &nbsp;
            num_spaces = len(line) - len(line.lstrip(' '))
            indent = '&nbsp;' * num_spaces
            trimmed = line.lstrip(' ')
            line_fmt = f"<b><font color='#64748b'>{l_idx:3d}</font></b>  {indent}{trimmed}"
            chunk_lines.append(line_fmt)
            
            if len(chunk_lines) >= chunk_size:
                chunk_text = "<br/>".join(chunk_lines)
                code_p = Paragraph(chunk_text, code_style)
                code_table = Table([[code_p]], colWidths=[487])
                code_table.setStyle(TableStyle([
                    ('BACKGROUND', (0, 0), (-1, -1), c_bg_code),
                    ('BOX', (0, 0), (-1, -1), 0.5, c_border_code),
                    ('LEFTPADDING', (0, 0), (-1, -1), 6),
                    ('RIGHTPADDING', (0, 0), (-1, -1), 6),
                    ('TOPPADDING', (0, 0), (-1, -1), 4),
                    ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
                ]))
                story.append(code_table)
                story.append(Spacer(1, 2))
                chunk_lines = []
                
        if chunk_lines:
            chunk_text = "<br/>".join(chunk_lines)
            code_p = Paragraph(chunk_text, code_style)
            code_table = Table([[code_p]], colWidths=[487])
            code_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, -1), c_bg_code),
                ('BOX', (0, 0), (-1, -1), 0.5, c_border_code),
                ('LEFTPADDING', (0, 0), (-1, -1), 6),
                ('RIGHTPADDING', (0, 0), (-1, -1), 6),
                ('TOPPADDING', (0, 0), (-1, -1), 4),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
            ]))
            story.append(code_table)
            
        story.append(Spacer(1, 14))
        story.append(HRFlowable(width="100%", thickness=0.5, color=colors.HexColor("#cbd5e1"), spaceAfter=12))
        
    print("Building PDF document...")
    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"PDF successfully generated at: {output_pdf_path}")
    
    # Copy to Desktop for easy user access
    try:
        import shutil
        shutil.copyfile(output_pdf_path, desktop_pdf_path)
        print(f"Copied PDF to Desktop: {desktop_pdf_path}")
    except Exception as e:
        print(f"Failed to copy to Desktop: {e}")

if __name__ == "__main__":
    main()

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createTermsAndConditions() async {
  final firestore = FirebaseFirestore.instance;

  final termsAndConditionsData = {
    'termsAndConditions': """
      <h1>Terms and Conditions</h1>
      <p><strong>1. Acceptance of Terms</strong></p>
      <p>By using the <strong>Scrap to Cash</strong> app, you agree to comply with and be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the app.</p>
      <p><strong>2. Service Description</strong></p>
      <p><strong>Scrap to Cash</strong> provides a platform for users to sell their scrap materials online. The service includes selecting scrap items, scheduling a pickup, and receiving payment.</p>
      <p><strong>3. User Responsibilities</strong></p>
      <ul>
        <li><strong>Eligibility:</strong> You must be at least 18 years old to use this service.</li>
        <li><strong>Accuracy:</strong> You are responsible for providing accurate information about the scrap items you wish to sell.</li>
        <li><strong>Compliance:</strong> You must ensure that the scrap materials you list comply with local regulations and are free from hazardous substances.</li>
      </ul>
      <p><strong>4. Pricing and Payments</strong></p>
      <ul>
        <li><strong>Pricing:</strong> The app displays current prices for scrap materials. Prices may vary based on market conditions.</li>
        <li><strong>Payment Methods:</strong> Payments can be made via cash, online transfer, or UPI. We reserve the right to modify payment methods.</li>
        <li><strong>Fees:</strong> We may charge fees for certain services, which will be disclosed before you complete the transaction.</li>
      </ul>
      <p><strong>5. Pickup and Delivery</strong></p>
      <ul>
        <li><strong>Scheduling:</strong> You can schedule a pickup time through the app. The pickup will be arranged at the address you provide.</li>
        <li><strong>Responsibility:</strong> You must ensure that the scrap is ready for pickup at the scheduled time. If the pickup cannot be completed due to issues on your end, additional charges may apply.</li>
      </ul>
      <p><strong>6. Limitation of Liability</strong></p>
      <p><strong>Scrap to Cash</strong> is not liable for any indirect, incidental, or consequential damages arising from the use of the app. Our liability is limited to the maximum extent permitted by law.</p>
      <p><strong>7. Changes to Terms</strong></p>
      <p>We reserve the right to modify these Terms and Conditions at any time. Changes will be effective immediately upon posting on the app. Your continued use of the app constitutes acceptance of the revised terms.</p>
      <p><strong>8. Contact Information</strong></p>
      <p>For any questions or concerns about these Terms and Conditions, please contact us at <a href="mailto:contact@scraptocash.in">contact@scraptocash.in</a>.</p>
    """
  };

  try {
    // Add document to Firestore
    await firestore
        .collection('app_info')
        .doc('terms_and_conditions')
        .set(termsAndConditionsData);
    log('Terms and Conditions added successfully');
  } catch (e) {
    log('Error adding Terms and Conditions: $e');
  }
}

Future<void> createPrivacyPolicy() async {
  final firestore = FirebaseFirestore.instance;

  final privacyPolicyData = {
    'privacyPolicy': """
      <h1>Privacy Policy</h1>
      <h3>1. <strong>Introduction</strong></h3>
      <p>At <strong>Scrap to Cash</strong>, we are committed to protecting your privacy. This Privacy Policy outlines how we collect, use, and safeguard your personal information when you use our app and services.</p>
      <h3>2. <strong>Information We Collect</strong></h3>
      <ul>
        <li><strong>Personal Information:</strong> When you use our app, we may collect personal information such as your name, address, phone number, and email address.</li>
        <li><strong>Scrap Details:</strong> Information about the scrap materials you wish to sell, including types and quantities.</li>
        <li><strong>Payment Information:</strong> Details related to your payment method, such as bank account numbers or UPI IDs.</li>
      </ul>
      <h3>3. <strong>How We Use Your Information</strong></h3>
      <ul>
        <li><strong>Service Delivery:</strong> To process your transactions, schedule pickups, and deliver payments.</li>
        <li><strong>Communication:</strong> To send you updates about your transactions, promotional offers, and other relevant information.</li>
        <li><strong>Improvement:</strong> To analyze usage patterns and improve our app and services.</li>
        <li><strong>Legal Compliance:</strong> To comply with legal requirements and resolve disputes.</li>
      </ul>
      <h3>4. <strong>How We Protect Your Information</strong></h3>
      <ul>
        <li><strong>Security Measures:</strong> We implement reasonable security measures to protect your personal information from unauthorized access, disclosure, alteration, or destruction.</li>
        <li><strong>Data Storage:</strong> Your information is stored securely on our servers and is only accessible to authorized personnel.</li>
      </ul>
      <h3>5. <strong>Sharing Your Information</strong></h3>
      <ul>
        <li><strong>Third Parties:</strong> We may share your information with third-party service providers who assist us in operating our app and providing services, such as payment processors and delivery partners. These third parties are bound by confidentiality agreements.</li>
        <li><strong>Legal Requirements:</strong> We may disclose your information if required by law or to protect our rights, property, or safety.</li>
      </ul>
      <h3>6. <strong>Cookies and Tracking Technologies</strong></h3>
      <ul>
        <li><strong>Cookies:</strong> Our app may use cookies to enhance your user experience. Cookies are small files stored on your device that help us understand how you use our app and remember your preferences.</li>
        <li><strong>Tracking:</strong> We may use tracking technologies to analyze app usage and improve our services.</li>
      </ul>
      <h3>7. <strong>Your Choices</strong></h3>
      <ul>
        <li><strong>Access and Correction:</strong> You can access and update your personal information through the app. If you need assistance, contact us at <a href="mailto:contact@scraptocash.in">contact@scraptocash.in</a>.</li>
        <li><strong>Opt-Out:</strong> You can opt out of receiving promotional communications by following the instructions provided in the emails or by contacting us directly.</li>
      </ul>
      <h3>8. <strong>Children’s Privacy</strong></h3>
      <p>Our app is not intended for use by individuals under the age of 18. We do not knowingly collect personal information from children. If we become aware that we have collected information from a child, we will take steps to delete it.</p>
      <h3>9. <strong>Changes to This Policy</strong></h3>
      <p>We may update this Privacy Policy from time to time. Changes will be posted on this page, and we will notify you of significant updates. Your continued use of our app after changes constitutes acceptance of the revised policy.</p>
      <h3>10. <strong>Contact Us</strong></h3>
      <p>If you have any questions or concerns about this Privacy Policy or our practices, please contact us at <a href="mailto:contact@scraptocash.in">contact@scraptocash.in</a>.</p>
    """
  };

  try {
    await firestore
        .collection('app_info')
        .doc('privacy_policy')
        .set(privacyPolicyData);
    log('Privacy Policy added successfully');
  } catch (e) {
    log('Error adding Privacy Policy: $e');
  }
}

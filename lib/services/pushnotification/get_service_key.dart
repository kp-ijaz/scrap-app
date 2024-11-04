import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    // Load environment variables
    await dotenv.load();

    final scopes = [
      'http://www.googleapis.com/auth/userinfo.email',
      'http://www.googleapis.com/auth/firebase.database',
      'http://www.googleapis.com/auth/firebase.messaging',
    ];

    // Create a service account credentials object from environment variables
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": dotenv.env['GOOGLE_PROJECT_ID'],
          "private_key_id":
              dotenv.env['GOOGLE_PRIVATE_KEY_ID'], // You can add this if needed
          "private_key":
              dotenv.env['GOOGLE_PRIVATE_KEY']!.replaceAll(r'\n', '\n'),
          "client_email": dotenv.env['GOOGLE_CLIENT_EMAIL'],
          "client_id": dotenv.env['GOOGLE_CLIENT_ID'],
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/${dotenv.env['GOOGLE_CLIENT_EMAIL']}",
        },
      ),
      scopes,
    );

    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}

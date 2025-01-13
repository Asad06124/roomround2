import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "roomround-34b5f",
        "private_key_id": "459aee9ad259d6105cb809930e0cd568ff45e13c",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQChVTchjc939RY6\nvAwBLbM26xtdtoQYv4I66KPEYbdstfMEO/3Xv/mJOVwz3qOk6M6fOWaqLo9CVGhO\n+M8YqwuDyJYMeUg1823BjsHkIGARwoz6dctgrOBmcyh1D6Ekznt3vTV0tbahb+/J\nLUmzjOQGIogSWdz2MDW2K54CUdidnL7FlrAJWVCizB7Ogo3JsFNGEhxmxqZ77wK/\nTJ57kmVwzioOVuMgSRvLpkPimvzd6FVcBmHdo6CdwrkvvVFFEdArftZOsIlq2IEv\n7m/ClY2AfN/SrEPaq7Gd7uXkejBjBNwcNF0F7rn3HiVDA+QjotSP0kd1Xw9PW0d+\nSykOfwUtAgMBAAECggEAGUctUrQSAEUl/QDuzpZ3AJFY4deRngEPqiQ+WKxI3Z8q\nmwy9Srs5IX+by0LEmDej/D21sM+HwchQ6aLBbCeMr9LTc9Pi9RUVquCvz4slElNN\n3IZtXdHofRTpD2JqCMbTgKDkScuY+HV9+CMA68GVDsMFV/69iNNn7wmpgcqKKrOf\nXu4rMHx1s1emWKCAOjBQ8d/+xpNMtkdx4fcSC3x5HfJoU9YouvLDeg93z8HNqR0U\nvPpr6vSXbFMQQGC4iZ1H1jXAK/H7DK5HsVnw7J64+++SRIirT0/gcbJRt8/SQtig\nPk86wIFxPhYrRHN/p5kmveDc6KIYpWfigGzbJoD4DwKBgQDMGKDs9cPEez+eU5p2\nmX+swQb/iMAKkDEjwxsRPrY0kYI2fDyew984kVDufld7FCK+bi+YWA/62mRkX0n6\nE4QdaTzWzogx1UshrBNz0lhayG0Wa2Ywm3eqKXZf7nUWirf307UcvCwgYnfUJKXS\nkDukr/TdlQ5/RnyNjDXp4vxwKwKBgQDKXIuav1PTYtzMdjLS36aOdPbz3fyOC4Y4\nzMbWAj9v5holTRuDC9zrWN/tEFta7GT5hARc6iWIMpJicLe6Nai8m00x4Wh57A2h\nvW3n5IfM5f60RagIDbLoNw9knPEeBEF/B3Qq/dRBz8y9E+Cj3cBBb/YTRHLJEDlK\nAw1EXxncBwKBgQCDpas/zbMOLLW3iZPLxm1NYGEEORAugB3CRJpUAFCFDgqg3Hg5\nrHxyv4ElpQcGk9FpZid7K+p6054IBFLyZN5GHlio8iV1h3Bj8tvFTLvDKx76ZCJR\nXibM8tuxO135QVczGzLqqxIHfZxvkYgIjxJ5wym+N+RXAn9aykMIb2qHawKBgHac\nCeO5ExwKjVp2SVHabxh+rCTCT36+eHygYkcb6CzhVR/Z8y87a9CyNgYQmUtQ1dp+\nK8R+JWOQKMb0RGwreWybJoL/GKql1lOf4WSTSZmqkUD+tv+Jb/y2ERqq9pTeb7lS\nGB/+yUON1fZZSUki98YjJruiWhlJnhqocUVK7LBPAoGAajU5vjAczMAs+T9gSUWw\niEMpgYE47q2/fWaYuDhfzWkZlGlX88gpsexDFJHTblaDzRzWrT+z0o+OWFstZ8qw\nP0L81SgeaMAxp7knzzzzv/HoHcoB/vwPqtGlrozi6D+gHMrSVfy/f9jx7keo0B9v\nXXiJuQZ+IKKklf7/lDc3Exg=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-qavud@roomround-34b5f.iam.gserviceaccount.com",
        "client_id": "114601407690693425388",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-qavud%40roomround-34b5f.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}

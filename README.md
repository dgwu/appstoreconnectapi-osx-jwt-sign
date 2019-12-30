# App Store Connect API JWT ES256 Generator MacOS GUI
To simplify App Store Connect JWT token generation.
Inspired by: [ikool-cn](https://github.com/ikool-cn/appstoreconnectapi-php-jwt-sign)

## Requirement
what you need:
- Issuer Id
- Key Id
- App Store Connect Private Key (.p8)

## Test your token
`curl -v -H 'Authorization: Bearer <YOUR TOKEN>' "https://api.appstoreconnect.apple.com/v1/apps"`



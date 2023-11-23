#!/bin/bash
if ! ( "$oidcDisable" == "true" );
  then
    echo "OIDCProviderMetadataURL 'https://$oidcDomain/.well-known/openid-configuration'" > /etc/apache2/mods-available/auth_openidc.conf
    echo "OIDCClientID '$oidcClientID'" >> /etc/apache2/mods-available/auth_openidc.conf
    echo "OIDCClientSecret '$oidcClientSecret'" >> /etc/apache2/mods-available/auth_openidc.conf
    #####
    echo "OIDCScope \"openid name email profile\"" >> /etc/apache2/mods-available/auth_openidc.conf
    echo "OIDCRedirectURI http://$siteURL/user_auth/" >> /etc/apache2/mods-available/auth_openidc.conf
    echo "OIDCCryptoPassphrase \"$OIDCCryptoPassphrase\"" >> /etc/apache2/mods-available/auth_openidc.conf
    #####
    echo "<Location />" >> /etc/apache2/mods-available/auth_openidc.conf
    echo "   AuthType openid-connect" >> /etc/apache2/mods-available/auth_openidc.conf
    echo "   Require valid-user" >> /etc/apache2/mods-available/auth_openidc.conf
    echo "   LogLevel debug" >> /etc/apache2/mods-available/auth_openidc.conf
    echo "</Location>" >> /etc/apache2/mods-available/auth_openidc.conf
    #####
    export OIDC_PASS_PHRASE="$OIDCCryptoPassphrase"
    export OIDC_METADATA_URL="https://$oidcDomain/.well-known/openid-configuration"
    export OIDC_CLIENT_ID="$oidcClientID"
    export OIDC_CLIENT_SECRET="$oidcClientSecret"
    export OIDC_SCOPE="openid name email profile"
    export OIDC_REDIRECT_URL="http://$siteURL/user_auth/"
    export OIDC_RESPONSE_TYPE="code"
    export OIDC_PASS_CLAILS_AS="environment"
    export OIDC_CLAIM_PREFIX="USERINFO_"
    export OIDC_PASS_ID_TOKEN_AS="payload"
    #####
    a2enmod auth_openidc
else
    a2dismod auth_openidc
fi

/run-httpd.sh

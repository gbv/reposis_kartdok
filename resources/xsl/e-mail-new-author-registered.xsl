<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" 
  exclude-result-prefixes="i18n">
  <xsl:param name="DefaultLang" />
  <xsl:param name="WebApplicationBaseURL" />
  <xsl:param name="ServletsBaseURL" />
  <xsl:param name="MCR.mir-module.NewUserMail" />
  <xsl:param name="MCR.mir-module.MailSender" />
  <xsl:variable name="newline" select="'&#xA;'" />

  <xsl:template match="/">
    <email>
      <from>
        <xsl:value-of select="$MCR.mir-module.MailSender" />
      </from>
      <xsl:apply-templates select="/*" mode="email" />
    </email>
  </xsl:template>

  <xsl:template match="user" mode="email">
    <to>
      <xsl:value-of select="$MCR.mir-module.NewUserMail" />
    </to>
    <subject>
      <xsl:value-of select="i18n:translate('mir.email.newauthor.registered.subject')" />
    </subject>
    <body>
      <xsl:value-of select="$newline" />
      <xsl:value-of select="i18n:translate('mir.email.newauthor.registered.bodytext')" />
      <xsl:value-of select="$newline" />
      <xsl:value-of select="$newline" />
      <xsl:value-of select="concat(i18n:translate('mir.email.name'),' ',@name,' (',@realm,')',$newline)" />
      <xsl:value-of select="concat(i18n:translate('mir.email.realname'),' ',realName,$newline)" />
      <xsl:value-of select="concat(i18n:translate('mir.email.eMail'),' ',eMail,$newline)" />
      <xsl:value-of select="concat(i18n:translate('mir.email.link'),' ',$ServletsBaseURL,'MCRUserServlet?action=show&amp;id=',@name,'@',@realm,$newline)" />
    </body>
  </xsl:template>
</xsl:stylesheet>

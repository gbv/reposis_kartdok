<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
    xmlns:mcrver="xalan://org.mycore.common.MCRCoreVersion"
    xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
    exclude-result-prefixes="i18n mcrver mcrxsl">

  <xsl:import href="resource:xsl/layout/mir-common-layout.xsl" />
  <xsl:param name="MIR.Matomo" select="false" />

  <xsl:template name="mir.navigation">

    <div id="options_nav_box" class="mir-prop-nav">
      <div class="container container-no-padding">
        <nav>
          <ul class="navbar-nav ml-auto flex-row">
            <xsl:call-template name="mir.loginMenu" />
            <xsl:call-template name="mir.languageMenu" />
          </ul>
        </nav>
      </div>
    </div>

    <div id="header_box" class="clearfix container container-no-padding">

      <div class="project_logo_box">
        <div class="project_logo">
          <a href="{concat($WebApplicationBaseURL,substring($loaded_navigation_xml/@hrefStartingPage,2),$HttpSession)}" title="Home" class="project-logo__link">
            <span class="fid logo main">
              KartDok
            </span>
            <span class="fid logo sub">
              Repositorium Kartographie
            </span>
          </a>
        </div>
        <div class="project_parent_logo">
          <a href="https://staatsbibliothek-berlin.de/">
            <img class="sbb-logo" alt="Logo der Staatsbibliothek zu Berlin" title="zur Seite der Staatsbibliothek zu Berlin" src="{$WebApplicationBaseURL}/images/SBB_Logo_sRGB_no_border.png" />
          </a>
        </div>
      </div>

    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="mir-main-nav">
      <div class="container container-no-padding">
        <nav class="navbar navbar-expand-lg navbar-light">

          <button
            class="navbar-toggler"
            type="button"
            data-toggle="collapse"
            data-target="#mir-main-nav__entries"
            aria-controls="mir-main-nav__entries"
            aria-expanded="false"
            aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>

          <div id="mir-main-nav__entries" class="collapse navbar-collapse mir-main-nav__entries">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
              <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='search']" />
              <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='publish']" />
              <xsl:call-template name="mir.basketMenu" />
            </ul>
          </div>

          <div class="searchBox">
            <xsl:variable name="core">
              <xsl:call-template name="getLayoutSearchSolrCore" />
            </xsl:variable>
            <form
              action="{$WebApplicationBaseURL}servlets/solr{$core}"
              class="searchfield_box form-inline my-2 my-lg-0"
              role="search">
              <input
                name="condQuery"
                placeholder="{i18n:translate('mir.navsearch.placeholder')}"
                class="form-control search-query"
                id="searchInput"
                type="text"
                aria-label="Search" />
              <xsl:if test="mcrxsl:isCurrentUserInRole('admin') or mcrxsl:isCurrentUserInRole('editor')">
                <input name="owner" type="hidden" value="createdby:*" />
              </xsl:if>
              <button type="submit" class="btn btn-primary-inverted my-2 my-sm-0">
                <i class="fas fa-search"></i>
              </button>
            </form>
          </div>

        </nav>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="mir.jumbotwo">

  </xsl:template>

  <xsl:template name="mir.footer">
    <div class="container container-no-padding">
      <div class="row">
        <div class="col-12">
          <ul class="internal_links nav navbar-nav">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='below']/*" mode="footerMenu" />
          </ul>
        </div>
      </div>
      <div class="row">
        <div class="col-12 d-flex justify-content-center logo-section">
          <a href="https://kartographie.staatsbibliothek-berlin.de/" title="FID Karten Home" class="logo">
            <span class="fid logo main">
              FID KARTEN
            </span>
            <span class="fid logo sub">
              Fachinformationsdienst<br />
              Kartographie und Geobasisdaten
            </span>
          </a>
          <a class="dfg logo" href="http://www.dfg.de" target="_blank">
            <span>Gefördert durch</span><br />
            <img class="dfg_logo img-fluid" src="{$WebApplicationBaseURL}/images/web_footer-dfg-weiss.png" />
          </a>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="kartdok.generate_single_menu_entry">
    <xsl:param name="menuID" />
    <li class="nav-item">
      <xsl:variable name="activeClass">
        <xsl:choose>
          <xsl:when test="$loaded_navigation_xml/menu[@id=$menuID]/item[@href = $browserAddress ]">
          <xsl:text>active</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>not-active</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <a id="{$menuID}" href="{$WebApplicationBaseURL}{$loaded_navigation_xml/menu[@id=$menuID]/item/@href}" class="nav-link {$activeClass}" >
        <xsl:choose>
          <xsl:when test="$loaded_navigation_xml/menu[@id=$menuID]/item/label[lang($CurrentLang)] != ''">
            <xsl:value-of select="$loaded_navigation_xml/menu[@id=$menuID]/item/label[lang($CurrentLang)]" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$loaded_navigation_xml/menu[@id=$menuID]/item/label[lang($DefaultLang)]" />
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </li>
  </xsl:template>

  <xsl:template name="mir.powered_by">
    <xsl:variable name="mcr_version" select="concat('MyCoRe ',mcrver:getCompleteVersion())" />
    <div id="powered_by">
      <a href="http://www.mycore.de">
        <img src="{$WebApplicationBaseURL}mir-layout/images/mycore_logo_small_invert.png" title="{$mcr_version}" alt="powered by MyCoRe" />
      </a>
    </div>

    <script type="text/javascript" src="{$WebApplicationBaseURL}js/jquery.cookiebar.js"></script>

    <!-- Matomo -->
    <!-- #KARTDOK-184 -->
    <xsl:if test="contains($MIR.Matomo, 'true')">
      <script>
        var _paq = window._paq = window._paq || [];
        _paq.push(['disableCookies']);
        _paq.push(['trackPageView']);
        _paq.push(['enableLinkTracking']);
        (function() {
        var u="https://webstats.sbb.berlin/";
        _paq.push(['setTrackerUrl', u+'matomo.php']);
        _paq.push(['setSiteId', '76']);
        var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
        g.type='text/javascript'; g.async=true; g.src=u+'matomo.js'; s.parentNode.insertBefore(g,s);
        })();
      </script>
    </xsl:if>
  </xsl:template>

  <xsl:template name="getLayoutSearchSolrCore">
    <xsl:choose>
      <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
        <xsl:text>/find</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>/findPublic</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

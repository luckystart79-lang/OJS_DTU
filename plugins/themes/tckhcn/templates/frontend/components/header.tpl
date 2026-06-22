{**
 * plugins/themes/tckhcn/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Custom site header matching DTU JST layout.
 *
 * Author: Vo Van Thuan - Trung Tâm CNPM CSE
 *}
{strip}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div class="pkp_structure_page">

		{* 1. Top bar: Language & Login *}
		<div class="lang-bar">
			<div class="container">
				{* Languages switcher *}
				<div class="lang-selector">
					{if $languageToggleLocales && $languageToggleLocales|@count > 1}
						<ul class="lang-links">
							{foreach from=$languageToggleLocales key=localeKey item=localeName}
								{if $localeKey !== $currentLocale}
									<li>
										<a href="{if $localeKey == 'en' || $localeKey == 'en_US'}{$toggleUrlEn}{else}{$toggleUrlVi}{/if}">
											{if $localeKey == 'en' || $localeKey == 'en_US'}
												<img src="https://flagcdn.com/w20/gb.png" alt="English">
											{else}
												<img src="https://flagcdn.com/w20/vn.png" alt="Tiếng Việt">
											{/if}
										</a>
									</li>
								{else}
									<li class="active">
										<img src="https://flagcdn.com/w20/{if $localeKey == 'en' || $localeKey == 'en_US'}gb{else}vn{/if}.png" alt="{$localeName}">
									</li>
								{/if}
							{/foreach}
						</ul>
					{else}
						{* Fallback if OJS locales are not fully loaded/configured *}
						<ul class="lang-links">
							{if $currentLocale == 'en_US' || $currentLocale == 'en'}
								<li><a href="{$toggleUrlVi}"><img src="https://flagcdn.com/w20/vn.png" alt="Tiếng Việt"></a></li>
								<li class="active"><img src="https://flagcdn.com/w20/gb.png" alt="English"></li>
							{else}
								<li class="active"><img src="https://flagcdn.com/w20/vn.png" alt="Tiếng Việt"></li>
								<li><a href="{$toggleUrlEn}"><img src="https://flagcdn.com/w20/gb.png" alt="English"></a></li>
							{/if}
						</ul>
					{/if}
				</div>

				{* User actions *}
				<div class="login-links">
					{if $isUserLoggedIn}
						<a href="{url router=\PKP\core\PKPApplication::ROUTE_PAGE page="user" op="profile"}">
							<i class="fa fa-user"></i> {$currentUser->getUsername()|escape}
						</a>
						{if array_intersect(array(ROLE_ID_SITE_ADMIN, ROLE_ID_MANAGER, ROLE_ID_SUB_EDITOR, ROLE_ID_ASSISTANT), $userRoles)}
							<a href="{url router=\PKP\core\PKPApplication::ROUTE_PAGE page="submissions"}">{translate key="navigation.dashboard"}</a>
						{/if}
						<a href="{url router=\PKP\core\PKPApplication::ROUTE_PAGE page="login" op="signOut"}"><i class="fa fa-sign-out"></i> {translate key="user.logOut"}</a>
					{else}
						<a href="{url router=\PKP\core\PKPApplication::ROUTE_PAGE page="login"}"><i class="fa fa-sign-in"></i> {translate key="navigation.login"}</a>
						<a href="{url router=\PKP\core\PKPApplication::ROUTE_PAGE page="user" op="register"}"><i class="fa fa-user-plus"></i> {translate key="navigation.register"}</a>
					{/if}
				</div>
			</div>
		</div>

		{* 2. Main Branding Header matching DTU JST *}
		<div class="header-top">
			<div class="container bg_header">
				<div class="header-row">
					<div class="logo-col">
						<div class="logo-dtu">
							<a href="{url page="index" router=\PKP\core\PKPApplication::ROUTE_PAGE}">
								<img src="{$baseUrl}/plugins/themes/tckhcn/images/logo_dtu_footer.png" alt="logo" />
							</a>
						</div>
						<div class="logo-meta hide_mobile">
							<div class="cls_web">
								<a href="http://dtu-jst.org.vn" title="{$currentContext->getLocalizedName()|escape}">http://dtu-jst.org.vn</a>
							</div>
							<p class="issn">ISSN: 1859 - 4905</p>
						</div>
					</div>
					<div class="header-title-col">
						<h1 class="title_main">{$currentContext->getLocalizedName()|escape}</h1>
						<p class="subtitle-main">{translate key="plugins.themes.tckhcn.subtitleMain"}</p>
					</div>
				</div>
			</div>
		</div>


		{* 3. Primary Navigation Bar *}
		<nav class="navigation-bar" aria-label="{translate|escape key="common.navigation.site"}">
			<div class="container">
				{* Primary menu rendered via OJS menu system *}
				{load_menu name="primary" id="navigationPrimary" ulClass="nav-menu" liClass="menu-item"}

				{* Search box *}
				{if $currentContext && $requestedPage !== 'search'}
					<div class="nav-search">
						<form method="get" action="{url page="search"}">
							<input type="text" name="query" placeholder="{translate key="plugins.themes.tckhcn.searchPlaceholder"}" required>
							<button type="submit"><i class="fa fa-search"></i></button>
						</form>
					</div>
				{/if}
			</div>
		</nav>

		{* 4. Wrapper for page content and sidebars *}
		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		
		<div class="homepage-container">
			<div class="main-layout">
				<div class="content-area" role="main">
					<a id="pkp_content_main"></a>

{**
 * plugins/themes/tckhcn/templates/frontend/components/footer.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Custom site footer matching DTU JST layout & international standards.
 *
 * Author: Vo Van Thuan - Trung Tâm CNPM CSE
 *}

				</div><!-- .content-area -->

				{* Sidebar Area: Displays OJS sidebar widgets inside our custom right column *}
				{if empty($isFullWidth)}
					<div class="sidebar-area" role="complementary" aria-label="{translate|escape key="common.navigation.sidebar"}">
						
						{* Custom submit manuscript button *}
						<a href="{url page="submission" op="wizard"}" class="btn-submit-manuscript">
							<i class="fa fa-paper-plane"></i> {translate key="plugins.themes.tckhcn.submitOnline"}
						</a>
						
						{* Custom Indexing databases block *}
						<div class="sidebar-section">
							<h3 class="sidebar-title">{translate key="plugins.themes.tckhcn.indexingDatabases"}</h3>
							<div class="indexing-logos">
								<a href="https://scholar.google.com" target="_blank" title="Google Scholar">
									<img src="https://upload.wikimedia.org/wikipedia/commons/c/c7/Google_Scholar_logo.svg" alt="Google Scholar">
								</a>
								<a href="https://www.crossref.org" target="_blank" title="Crossref/DOI">
									<img src="https://www.crossref.org/assets/images/Crossref_logo_300%E5%AE%BD.svg" alt="Crossref">
								</a>
								<a href="https://doaj.org" target="_blank" title="DOAJ">
									<img src="https://doaj.org/images/doaj-logo.svg" alt="DOAJ" style="background-color: #2b2b2b; padding: 5px; border-radius: 2px;">
								</a>
								<a href="https://www.scopus.com" target="_blank" title="Scopus">
									<img src="https://upload.wikimedia.org/wikipedia/commons/b/b8/Scopus_logo.svg" alt="Scopus">
								</a>
							</div>
						</div>
						
						{* Custom Policies block *}
						<div class="sidebar-section">
							<h3 class="sidebar-title">{translate key="plugins.themes.tckhcn.policiesRegulations"}</h3>
							<ul class="sidebar-info-list">
								<li><a href="{url page="about"}"><i class="fa fa-chevron-right"></i> {translate key="plugins.themes.tckhcn.doubleBlindReview"}</a></li>
								<li><a href="{url page="about"}"><i class="fa fa-chevron-right"></i> {translate key="plugins.themes.tckhcn.plagiarismPolicy"}</a></li>
								<li><a href="{url page="about"}"><i class="fa fa-chevron-right"></i> {translate key="plugins.themes.tckhcn.openAccessStatement"}</a></li>
							</ul>
						</div>

						{* Standard OJS sidebar blocks (login, info, language, custom blocks) *}
						{call_hook name="Templates::Common::Sidebar"}
					</div><!-- .sidebar-area -->
				{/if}
			</div><!-- .main-layout -->
		</div><!-- .homepage-container -->

		{* Footer Section *}
		<footer class="footer-wrapper" role="contentinfo">
			<div class="container">
				<div class="footer-columns">
					{* Column 1: Publisher & Publishing Info with Logo *}
					<div class="publisher-info-col">
						<div class="footer-logo-row">
							<div class="footer-logo-img">
								<img src="{$baseUrl}/plugins/themes/tckhcn/images/logo_dtu_footer.png" alt="Logo DTU" />
							</div>
							<div class="footer-logo-info">
								<h3 class="col-title-main">{translate key="plugins.themes.tckhcn.journalTitle"}</h3>
								{assign var="footerSubtitle" value={translate key="plugins.themes.tckhcn.journalSubtitle"}}
								{if $footerSubtitle}
									<p class="title-en">{$footerSubtitle}</p>
								{/if}
								<p>{translate key="plugins.themes.tckhcn.publisher"}</p>
								<p>ISSN: 1859 - 4905</p>
								<p>{translate key="plugins.themes.tckhcn.licenseNumber"}</p>
								<p>{translate key="plugins.themes.tckhcn.editorInChief"}</p>
								
								{* Creative Commons License statement - placed discreetly for international open-access standards *}
								<div class="licensing-block">
									<a rel="license" href="https://creativecommons.org/licenses/by/4.0/" target="_blank">
										<img alt="Creative Commons License" src="https://mirrors.creativecommons.org/presskit/buttons/88x31/png/by.png" style="filter: brightness(0) invert(1); height: 26px; vertical-align: middle; margin-right: 8px;" />
									</a>
									<span>CC BY 4.0</span>
								</div>
							</div>
						</div>
					</div>

					{* Column 2: Contact Info *}
					<div class="contact-info-col">
						<h3 class="col-title">{translate key="plugins.themes.tckhcn.contact"}</h3>
						<p><i class="fa fa-map-marker"></i> {translate key="plugins.themes.tckhcn.contactAddress"}</p>
						<p><i class="fa fa-phone"></i> 0236.3.827111 (ext 11336)</p>
						<p><i class="fa fa-fax"></i> 0236.3.650443</p>
						<p><i class="fa fa-envelope"></i> <a href="mailto:tapchikhcn@duytan.edu.vn">tapchikhcn@duytan.edu.vn</a></p>
					</div>
				</div>

				{* Copyright and Social Bar *}
				<div class="copyright-bar">
					<p>2026 &copy; {translate key="plugins.themes.tckhcn.copyright"}</p>
					<div class="social-icons">
						<a href="https://www.facebook.com/Duy.Tan.University" target="_blank" title="Facebook"><i class="fab fa-facebook-f"></i></a>
						<a href="https://twitter.com/UniDuyTan" target="_blank" title="Twitter"><i class="fab fa-twitter"></i></a>
						<a href="https://www.youtube.com/DuyTanUniversity" target="_blank" title="Youtube"><i class="fab fa-youtube"></i></a>
					</div>
				</div>
			</div>
		</footer>

	</div><!-- .pkp_structure_page -->

	{load_script context="frontend"}
	{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>

{**
 * plugins/themes/tckhcn/templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Custom journal homepage template matching DTU JST layout.
 *
 * Author: Vo Van Thuan - Trung Tâm CNPM CSE
 *}
{assign var=isFullWidth value=true}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}


{* 1. About the Journal Section (Block 1) *}
<section class="about-block">
	<div class="about-image">
		<img src="{$baseUrl}/plugins/themes/tckhcn/images/journal_about_banner.jpg" alt="{translate key="plugins.themes.tckhcn.aboutBannerAlt"}" />
	</div>
	<div class="about-content">
		<h2>{translate key="plugins.themes.tckhcn.aboutContext"}</h2>
		<p>
			{if $currentContext->getLocalizedData('description')}
				{$currentContext->getLocalizedData('description')|strip_unsafe_html|truncate:1000:"..."}
			{else}
				Tạp chí Khoa học và Công nghệ Đại học Duy Tân (DTU Journal of Science and Technology).
			{/if}
		</p>
		<a href="{url page="about"}" class="btn-more">{translate key="plugins.themes.tckhcn.readMore"}</a>
	</div>
</section>

{* 2. Current Issue Section (Block 2) *}
{if $issue}
	<section class="current-issue-section">
		<div class="section-header">
			<h2>{translate key="plugins.themes.tckhcn.currentIssue"}</h2>
			<a href="{url page="issue" op="archive"}" class="view-archive">
				{translate key="plugins.themes.tckhcn.viewAll"} <i class="fa fa-chevron-right"></i>
			</a>
		</div>

		{* Include our custom issue TOC layout *}
		{include file="frontend/objects/issue_toc.tpl" heading="h3"}
	</section>
{else}
	<section class="current-issue-section">
		<div class="section-header">
			<h2>{translate key="plugins.themes.tckhcn.currentIssue"}</h2>
		</div>
		<p class="text-muted">{translate key="plugins.themes.tckhcn.noIssues"}</p>
	</section>
{/if}

{* 3. Journal Categories Section (Chuyên mục Tạp chí) *}
<section class="journal-categories-section">
	<div class="section-header">
		<h2>{translate key="plugins.themes.tckhcn.categories"}</h2>
	</div>
	<div class="categories-grid">
		{if $homepageSections && $homepageSections|@count > 1}
			{* Dynamic DB Sections *}
			{foreach from=$homepageSections item=section}
				<div class="category-card">
					{assign var="sectionImgUrl" value="https://images.unsplash.com/photo-1507668077129-56e32842fceb?auto=format&fit=crop&w=500&q=80"}
					{if $section->getId() == 1}
						{assign var="sectionImgUrl" value="https://images.unsplash.com/photo-1507668077129-56e32842fceb?auto=format&fit=crop&w=500&q=80"}
					{elseif $section->getId() == 2}
						{assign var="sectionImgUrl" value="https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=500&q=80"}
					{elseif $section->getId() == 3}
						{assign var="sectionImgUrl" value="https://images.unsplash.com/photo-1489533119213-66a5cd877091?auto=format&fit=crop&w=500&q=80"}
					{elseif $section->getId() == 4}
						{assign var="sectionImgUrl" value="https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=500&q=80"}
					{elseif $section->getId() == 5}
						{assign var="sectionImgUrl" value="https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=500&q=80"}
					{elseif $section->getId() == 6}
						{assign var="sectionImgUrl" value="https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=500&q=80"}
					{/if}
					<div class="category-card-img" style="background-image: url('{$sectionImgUrl}');"></div>
					<div class="category-card-content">
						<p class="cat-name">{$section->getLocalizedTitle()|escape}</p>
						<a class="btn-category" href="{url page="search" query=$section->getLocalizedTitle()}">
							{translate key="plugins.themes.tckhcn.publishedArticles"} <i class="fa fa-chevron-right"></i>
						</a>
					</div>
				</div>
			{/foreach}
		{else}
			{* Localized Fallback 6 Categories *}
			<div class="category-card">
				<div class="category-card-img" style="background-image: url('https://images.unsplash.com/photo-1507668077129-56e32842fceb?auto=format&fit=crop&w=500&q=80');"></div>
				<div class="category-card-content">
					<p class="cat-name">{translate key="plugins.themes.tckhcn.cat.engineering"}</p>
					<a class="btn-category" href="{url page="search" query={translate key="plugins.themes.tckhcn.cat.engineering.query"}}">
						{translate key="plugins.themes.tckhcn.publishedArticles"} <i class="fa fa-chevron-right"></i>
					</a>
				</div>
			</div>
			<div class="category-card">
				<div class="category-card-img" style="background-image: url('https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=500&q=80');"></div>
				<div class="category-card-content">
					<p class="cat-name">{translate key="plugins.themes.tckhcn.cat.natural"}</p>
					<a class="btn-category" href="{url page="search" query={translate key="plugins.themes.tckhcn.cat.natural.query"}}">
						{translate key="plugins.themes.tckhcn.publishedArticles"} <i class="fa fa-chevron-right"></i>
					</a>
				</div>
			</div>
			<div class="category-card">
				<div class="category-card-img" style="background-image: url('https://images.unsplash.com/photo-1489533119213-66a5cd877091?auto=format&fit=crop&w=500&q=80');"></div>
				<div class="category-card-content">
					<p class="cat-name">{translate key="plugins.themes.tckhcn.cat.social"}</p>
					<a class="btn-category" href="{url page="search" query={translate key="plugins.themes.tckhcn.cat.social.query"}}">
						{translate key="plugins.themes.tckhcn.publishedArticles"} <i class="fa fa-chevron-right"></i>
					</a>
				</div>
			</div>
			<div class="category-card">
				<div class="category-card-img" style="background-image: url('https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=500&q=80');"></div>
				<div class="category-card-content">
					<p class="cat-name">{translate key="plugins.themes.tckhcn.cat.health"}</p>
					<a class="btn-category" href="{url page="search" query={translate key="plugins.themes.tckhcn.cat.health.query"}}">
						{translate key="plugins.themes.tckhcn.publishedArticles"} <i class="fa fa-chevron-right"></i>
					</a>
				</div>
			</div>
			<div class="category-card">
				<div class="category-card-img" style="background-image: url('https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=500&q=80');"></div>
				<div class="category-card-content">
					<p class="cat-name">{translate key="plugins.themes.tckhcn.cat.interdisciplinary"}</p>
					<a class="btn-category" href="{url page="search" query={translate key="plugins.themes.tckhcn.cat.interdisciplinary.query"}}">
						{translate key="plugins.themes.tckhcn.publishedArticles"} <i class="fa fa-chevron-right"></i>
					</a>
				</div>
			</div>
			<div class="category-card">
				<div class="category-card-img" style="background-image: url('https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=500&q=80');"></div>
				<div class="category-card-content">
					<p class="cat-name">{translate key="plugins.themes.tckhcn.cat.humanities"}</p>
					<a class="btn-category" href="{url page="search" query={translate key="plugins.themes.tckhcn.cat.humanities.query"}}">
						{translate key="plugins.themes.tckhcn.publishedArticles"} <i class="fa fa-chevron-right"></i>
					</a>
				</div>
			</div>
		{/if}
	</div>
</section>

{* 4. Additional Homepage Content (if configured in OJS admin) *}
{if $additionalHomeContent}
	<div class="additional-content-block" style="background-color: #ffffff; border: 1px solid #e9ecef; border-radius: 8px; padding: 30px; box-shadow: 0 4px 12px rgba(0,0,0,0.02); margin-top: 30px;">
		{$additionalHomeContent}
	</div>
{/if}

{include file="frontend/components/footer.tpl"}

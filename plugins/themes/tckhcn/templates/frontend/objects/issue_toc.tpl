{**
 * plugins/themes/tckhcn/templates/frontend/objects/issue_toc.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Custom Table of Contents of an Issue matching DTU JST layout (two columns).
 *}
<div class="obj_issue_toc">
	{* Check if this is a preview *}
	{if !$issue->getPublished()}
		{include file="frontend/components/notification.tpl" type="warning" messageKey="editor.issues.preview"}
	{/if}

	<div class="issue-layout-row">
		{* 1. Left Column: Cover Image & Issue Info (col-sm-3 equivalent) *}
		<div class="issue-cover-col">
			<div class="issue-cover">
				{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
				{if $issueCover}
					<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:$issue->getIssueIdentification()|escape}">
				{else}
					{* Standard fallback cover matching Duy Tan JST cover style *}
					<img src="{$baseUrl}/plugins/themes/tckhcn/images/issue_cover.png" alt="Cover Page">
				{/if}

			</div>
			
			<div class="vol-info">
				<p class="journal-name">
					<i class="fa fa-book"></i>
					<span>{$issue->getIssueIdentification()|strip_unsafe_html}</span>
				</p>
				{if $issue->getDatePublished()}
					<p class="vol_publish_date">{translate key="submissions.published"}: {$issue->getDatePublished()|date_format:$dateFormatShort}</p>
				{/if}
				
				{* Show Issue DOI if exists *}
				{assign var=doiObject value=$issue->getData('doiObject')}
				{if $doiObject}
					{assign var="doiUrl" value=$doiObject->getData('resolvingUrl')|escape}
					<p class="vol_doi"><i class="fa fa-link"></i> {translate key="plugins.themes.tckhcn.issueDoi"}: <a href="{$doiUrl}" target="_blank">{$doiUrl}</a></p>
				{/if}
			</div>
		</div>

		{* 2. Right Column: Articles grouped by sections (col-sm-9 equivalent) *}
		<div class="issue-content-col">
			<div class="sections">
				{foreach name=sections from=$publishedSubmissions item=section}
					{if $section.articles}
						<div class="toc-section">
							{if $section.title}
								<h4 class="section-title"><i class="fa fa-tag"></i> {$section.title|escape}</h4>
							{/if}
							
							{foreach from=$section.articles item=article}
								{include file="frontend/objects/article_summary.tpl" article=$article}
							{/foreach}
						</div>
					{/if}
				{/foreach}
			</div>
		</div>
	</div>
</div>

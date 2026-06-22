{**
 * plugins/themes/tckhcn/templates/frontend/pages/editorialTeam.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Custom page to view the editorial team dynamically.
 *
 * Author: Vo Van Thuan - Trung Tâm CNPM CSE
 *}
{include file="frontend/components/header.tpl" pageTitle="about.editorialTeam"}

<div class="container page-container">
	<div class="page page_editorial_team">
		{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.editorialTeam"}
		
		<div class="page-header text-center mb-5">
			<h1 class="page-title text-uppercase font-weight-bold" style="color: #A32223; margin-bottom: 10px;">
				{translate key="about.editorialTeam"}
			</h1>
			<hr style="width: 80px; border-top: 3px solid #A32223; margin: 0 auto 30px auto;">
		</div>

		{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.editorialTeam"}
		
		{* Static intro content from OJS context settings *}
		{if $currentContext->getLocalizedData('editorialTeam')}
			<div class="editorial-team-intro mb-5">
				{$currentContext->getLocalizedData('editorialTeam')}
			</div>
		{/if}

		{* Dynamic Editorial Board Groups *}
		{if $editorialBoardGroups}
			<div class="editorial-board-groups mt-5">
				{foreach from=$editorialBoardGroups item=group}
					<div class="editorial-group-block mb-5">
						<h3 class="editorial-group-title text-uppercase pb-2 mb-4" style="border-bottom: 2px solid #eaeaea; color: #333; font-weight: 600;">
							{$group.groupName|escape}
						</h3>
						<div class="row">
							{foreach from=$group.members item=member}
								<div class="col-md-6 mb-4">
									<div class="card h-100 border-light shadow-sm" style="border-radius: 8px; transition: transform 0.2s, box-shadow 0.2s;">
										<div class="card-body p-4">
											<h4 class="card-title font-weight-bold mb-2" style="color: #A32223; font-size: 1.15rem;">
												{$member.fullName|escape}
											</h4>
											{if $member.affiliation}
												<p class="card-text text-muted mb-3" style="font-size: 0.95rem; line-height: 1.4;">
													{$member.affiliation|escape}
												</p>
											{/if}
											<div class="member-contacts d-flex flex-wrap align-items-center" style="font-size: 0.85rem; gap: 15px;">
												{if $member.email}
													<span class="member-email text-muted">
														<a href="mailto:{$member.email|escape}" class="text-secondary" style="text-decoration: none;">
															<i class="fa fa-envelope" style="color: #888; margin-right: 5px;"></i>{$member.email|escape}
														</a>
													</span>
												{/if}
												{if $member.orcid}
													<span class="member-orcid">
														<a href="https://orcid.org/{$member.orcid|escape}" target="_blank" style="color: #a6ce39; text-decoration: none; font-weight: 500;">
															<svg viewBox="0 0 24 24" width="16" height="16" style="vertical-align: middle; fill: #a6ce39; margin-right: 4px;"><path d="M12 0C5.372 0 0 5.372 0 12s5.372 12 12 12 12-5.372 12-12S18.628 0 12 0zM7.369 4.378c.541 0 .98.439.98.98s-.439.98-.98.98-.98-.439-.98-.98.439-.98.98-.98zm-.554 2.922h1.107v11.542H6.815V7.3zm4.244 0h1.76l.107 1.47h.054c.484-.961 1.436-1.636 2.585-1.636 2.057 0 3.328 1.442 3.328 3.73v7.978h-2.128v-7.39c0-1.472-.656-2.28-1.742-2.28-1.127 0-2.023.864-2.023 2.308v7.362h-2.128l-.054-11.542z"/></svg>ORCID
														</a>
													</span>
												{/if}
												{if $member.url}
													<span class="member-scholar">
														<a href="{$member.url|escape}" target="_blank" class="text-info" style="text-decoration: none;">
															<i class="fa fa-graduation-cap" style="margin-right: 5px;"></i>Hồ sơ khoa học
														</a>
													</span>
												{/if}
											</div>
										</div>
									</div>
								</div>
							{/foreach}
						</div>
					</div>
				{/foreach}
			</div>
		{/if}
	</div><!-- .page -->
</div>

{include file="frontend/components/footer.tpl"}

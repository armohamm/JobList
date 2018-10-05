import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { JobSearchComponent } from '../job-search/job-search.component';
import { ResumesSearchComponent } from '../resumes-search/resumes-search.component';
import { CompanyDetailsComponent } from '../company-details/company-details.component';
import { ResumeDetailsComponent } from '../resume-details/resume-details.component';
import { VacancyDetailsComponent } from '../vacancy-details/vacancy-details.component';

import { HomeComponent } from './home.component';

const childRoutes: Routes = [
  { path: 'jobsearch', component: JobSearchComponent},
  { path: 'resumessearch', component: ResumesSearchComponent },
  { path: 'company-details', component: CompanyDetailsComponent},
  { path: 'resume-details', component: ResumeDetailsComponent },
  { path: 'vacancy-details', component: VacancyDetailsComponent}
];

const routes: Routes = [
  {path: '', component: HomeComponent, children: childRoutes}
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class HomeRoutingModule { }

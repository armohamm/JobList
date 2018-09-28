import { NgModule, Optional, SkipSelf } from '@angular/core';
import { throwIfAlreadyLoaded } from './guards/module-import.guard';
import { CommonModule } from '@angular/common';
import { CompanyService } from './services/company.service';
import { ApiService } from './services/api.service';

@NgModule({
  imports: [
    CommonModule
  ],
  providers: [
		ApiService,
		CompanyService
  ],
  declarations: []
})
export class CoreModule {
  constructor(@Optional() @SkipSelf() parentModule: CoreModule) {
    throwIfAlreadyLoaded(parentModule, 'CoreModule');
  }
}

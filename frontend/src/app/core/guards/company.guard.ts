import { CanActivate, Router } from '@angular/router';
import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { AuthHelper } from '../../shared/helpers/auth-helper';
import { Observable } from 'rxjs';

@Injectable()

export class CompanyGuard implements CanActivate {

  constructor(private router: Router, private authHelper: AuthHelper) {}

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<boolean> | boolean {

    const currentUser = this.authHelper.getCurrentUser();

    if (currentUser === null) {

      this.router.navigate(['/']);
      return false;

    }

    if (currentUser.role === 'company'  && route.params['id'] === currentUser.id) {

      return true;

    } else {

      this.router.navigate(['/']);
      return false;

    }

  }

}

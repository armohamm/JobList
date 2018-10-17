import { Component, OnInit } from '@angular/core';
import { MenuItem } from 'primeng/api';

@Component({
  selector: 'app-admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.sass']
})
export class AdminComponent implements OnInit {

  visibleForUser: boolean = true;
  itemsForUser: MenuItem[];

  constructor() { }

  ngOnInit() {
    this.itemsForUser = [
      {
        label: 'Dashboard',
        icon: 'fa fa-home',
        routerLink: '/admin/admin-dashboard'
      },
      {
        label: 'Users',
        icon: 'fa fa-users',
        routerLink: '/admin/admin-users'
      },
      {
        label: 'Companies',
        icon: 'fa fa-university',
        routerLink: '/admin/admin-companies'
      },
      {
        label: 'Recruiters',
        icon: 'fa fa-user-secret',
        routerLink: '/admin/admin-recruiters'
      },
      {
        label: 'Vacancies',
        icon: 'fa fa-address-card',
        routerLink: '/admin/admin-vacancies'
      },
      {
        label: 'Settings',
        icon: 'fa fa-cog',
      }
    ];
  }
}

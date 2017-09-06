import { InjectionToken } from '@angular/core';

export let APP_CONFIG = new InjectionToken<AppConfig>('app.config');

export interface AppConfig {
  username: string;
  password: string;
  restRoot: string;
}

export const SLIDESHOW_CONFIG: AppConfig = {
    username: 'slideshow-user',
    password: 'sideshow-b0b',
    restRoot: 'http://localhost:8070/v1/resources/'
};

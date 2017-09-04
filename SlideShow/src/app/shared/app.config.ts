import { InjectionToken } from '@angular/core';
import { AppConfig} from './app.config-t';

export let APP_CONFIG = new InjectionToken<AppConfig>('app.config');

export const SLIDESHOW_CONFIG: AppConfig = {
    username: 'slideshow-user',
    password: 'sideshow-b0b',
    restRoot: 'http://localhost:8070/v1/resources/'
};

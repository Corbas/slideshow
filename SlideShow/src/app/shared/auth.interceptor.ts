import { Injectable, Inject } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';

import { Observable } from 'rxjs/Observable';

import {AppConfig } from './app.config-t';
import {  SLIDESHOW_CONFIG } from './app.config';


@Injectable()
export class BasicAuthInterceptor implements HttpInterceptor {

  private token: string;

  constructor( @Inject(SLIDESHOW_CONFIG) config: AppConfig) {
    this.token = btoa(config.username + ':' + config.password);
  }

  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {

    request = request.clone({
      setHeaders: {
        Authorization: `Basic ${this.token}:`
      }
    });

    return next.handle(request);
  }
}

import { Injectable, Inject } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';

import { Observable } from 'rxjs/Observable';

import {  AppConfig } from './app.config';


@Injectable()
export class BasicAuthInterceptor implements HttpInterceptor {

  private token: string;

  constructor( @Inject(AppConfig) config: AppConfig) {
    this.token = btoa(config.username + ':' + config.password);
    console.log('Token set to ' + this.token);
  }

  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {

    console.log('Interceptor called');

    const new_request = request.clone({
      setHeaders: {
        Authorization: `Basic ${this.token}:`
      }
    });

    return next.handle(new_request);
  }
}

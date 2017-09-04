// This interface is in this module because TypeScript gives a warning if anything but
// an interface is exported from a file (so no multiple exports with interfaces?)
export interface AppConfig {
   username: string;
   password: string;
   restRoot: string;
}

import { BrowserModule }          from '@angular/platform-browser';
import { NgModule }               from '@angular/core';
import { FormsModule }            from '@angular/forms';
import { HttpModule }             from '@angular/http';
import { Ng2BootstrapModule }     from 'ng2-bootstrap/ng2-bootstrap';
import { ModalModule }            from 'angular2-modal';
import { BootstrapModalModule }   from 'angular2-modal/plugins/bootstrap';
import { Angular2TokenService }   from 'angular2-token';
import { Ng2Bs3ModalModule }      from 'ng2-bs3-modal/ng2-bs3-modal';
import { CustomFormsModule }      from 'ng2-validation'
import { LocalStorageService,
         LOCAL_STORAGE_SERVICE_CONFIG
}                                  from 'angular-2-local-storage';
import { SearchPipe }             from './pipe/search.pipe';
import { LandingComponent }       from './components/landing.component';
import { ChannelsComponent }      from './components/channels.component';
import { LoginComponent }         from './components/login.component';
import { AppComponent }           from './components/app.component';
import { RegisterComponent }      from './components/register.component'
import { SetupComponent }         from './components/setup.component';
import { NavbarComponent }        from './components/navbar.component';
import { PlaylistsComponent }     from './components/playlists.component';
import { SongsComponent }         from './components/songs.component';
import { PlayerComponent }        from './components/player.component'
import { ChannelService }         from './services/channel.service';
import { FileDropDirective }      from 'ng2-file-upload';
import { routing }                from './app.routing';

let localStorageServiceConfig = {
  prefix: 'my-app',
  storageType: 'sessionStorage'
};

@NgModule({
  declarations: [
    SearchPipe,
    FileDropDirective,
    AppComponent,
    ChannelsComponent,
    LandingComponent,
    LoginComponent,
    RegisterComponent,
    SetupComponent,
    NavbarComponent,
    PlaylistsComponent,
    SongsComponent,
    PlayerComponent
  ],
  imports: [
    BrowserModule,
    CustomFormsModule,
    FormsModule,
    HttpModule,
    routing,
    Ng2BootstrapModule,
    ModalModule.forRoot(),
    BootstrapModalModule,
    Ng2Bs3ModalModule
  ],
  providers: [
    ChannelService,
    Angular2TokenService,
    LocalStorageService,
    {
      provide: LOCAL_STORAGE_SERVICE_CONFIG, useValue: localStorageServiceConfig
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }

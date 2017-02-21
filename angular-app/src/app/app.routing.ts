import { ModuleWithProviders }  from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ChannelsComponent }    from './components/channels.component';
import { LandingComponent }     from './components/landing.component';
import { LoginComponent }       from './components/login.component';
import { RegisterComponent }    from './components/register.component';
import { SetupComponent }       from './components/setup.component';
import { PlaylistsComponent }   from './components/playlists.component';
import { SongsComponent }       from './components/songs.component';
import { PlayerComponent }      from './components/player.component'

const appRoutes: Routes = [
    {
        path: '',
        redirectTo: '/landing',
        pathMatch: 'full'
    },
    {
        path: 'landing',
        component: LandingComponent
    },
    {
        path: 'channels',
        component: ChannelsComponent
    },
    {
        path: 'login',
        component: LoginComponent
    },
    {
        path: 'logout',
        component: LoginComponent
    },
    {
        path: 'register',
        component: RegisterComponent
    },
    {
        path: 'setup',
        component: SetupComponent
    },
    {
        path: 'playlists',
        component: PlaylistsComponent
    },
    {
        path: 'songs',
        component: SongsComponent
    },
    {
        path: 'player',
        component: PlayerComponent
    }
]

export const routing: ModuleWithProviders = RouterModule.forRoot(appRoutes, { useHash: true });

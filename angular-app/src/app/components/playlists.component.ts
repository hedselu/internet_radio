import { Component, ViewEncapsulation, ViewChild } from '@angular/core';
import { LocalStorageService }         from 'angular-2-local-storage';
import { Angular2TokenService }        from 'angular2-token';
import { ModalComponent }              from 'ng2-bs3-modal/ng2-bs3-modal';
import { Playlist }                    from '../models/playlist.models';
import { Song }                        from '../models/song.models';

@Component({
  selector: 'playlist',
  templateUrl: '../templates/playlists.component.html',
  encapsulation: ViewEncapsulation.None
})
//TODO
//move data fetching to external services
export class PlaylistsComponent {
  @ViewChild('songsAddition') modal: ModalComponent;

  private selectedPlaylistSongsIds: number[];
  private selectedPlaylist: Playlist;
  private songs: Song[];
  private playlists: Playlist[];
  private name: string;
  private description: string;

  constructor(
    public _tokenService: Angular2TokenService,
    private localStorageService: LocalStorageService
  ) { }

  ngOnInit(): void {
    this.getSongsFromStorage();
    console.log(this.songs)
    if (this.songs === null) {
      this.getSongsFromRemote();
    }

    this.getPlaylistsFromStorage();
    if (this.playlists === null) {
      this.getPlaylistsFromRemote()
    }
        this.selectedPlaylistSongsIds = [];
  }

  private getPlaylistsFromStorage(): void {
    var playlistsString = this.localStorageService.get('playlists');
    if (typeof playlistsString === 'string') {
      var playlistsJson = JSON.parse(playlistsString);
      this.playlists = playlistsJson as Playlist[];
    }
  }

  private getPlaylistsFromRemote(): void {
    this._tokenService.get('playlists')
      .map(res => res.json() as Playlist[])
      .subscribe(
      playlists => {
        console.log(playlists)
        this.playlists = playlists;
        var playlistsJson = JSON.stringify(this.playlists)
        this.localStorageService.set('playlists', playlistsJson)
      },
      error => this.handleError(error)
      );
  }

  private getSongsFromStorage(): void {
    var songsString = this.localStorageService.get('songs');
    if (typeof songsString === 'string') {
      var songsJson = JSON.parse(songsString);
      this.songs = songsJson as Song[];
    }
  }

  private getSongsFromRemote(): void {
    this._tokenService.get('songs')
      .map(res => res.json() as Song[])
      .subscribe(
      songs => {
        this.songs = songs;
        var songsJson = JSON.stringify(this.songs);
        this.localStorageService.set('songs', songsJson);
      },
      error => this.handleError(error)
      );
  }

  create(): void {
    this._tokenService.post('playlists', { playlist: { description: this.description, name: this.name } })
      .map(res => res.json() as Playlist)
      .subscribe(
      playlist => {
        this.playlists.push(playlist)
        this.updateLocalStorage()
      },
      error => this.handleError(error)
      );
  }

  select(playlist: Playlist): void {
    if(playlist !== this.selectedPlaylist){
        this.selectedPlaylist = playlist;
        this.selectedPlaylistSongsIds = [];
    }
  }

  removeSongFromSelected(songId: number): void {
    this.selectedPlaylistSongsIds = this.selectedPlaylistSongsIds.filter(id => id !== songId);
  }

  manageSongsOfSelected(): void {
    this.selectSongsIds();
    this.modal.open()
  }

  update(): void {
    this.modal.close();

    this._tokenService.put('playlists/' + this.selectedPlaylist.id, { playlist: { song_ids: this.selectedPlaylistSongsIds } })
      .map(res => res.json() as Playlist)
      .subscribe(
      playlist => this.updateInPlaylists(playlist),
      error => this.handleError(error)
      );
  }

  updateInPlaylists(playlist: Playlist): void {
    var index = this.getIndexById(playlist.id)
    this.playlists[index] = playlist
  }

  destroy(): void {
    this._tokenService.delete('playlists/' + this.selectedPlaylist.id)
      .subscribe(
      response => {
          this.removeFromPlaylists()
          this.updateLocalStorage()
      },
      err => this.handleError(err)
      )
  }

  selectedContainsSong(songId: number): boolean {
    var data = this.selectedPlaylistSongsIds.find(function(id) {
      return id === songId;
    });
    return !!data;
  }

  private updateLocalStorage(): void {
    var playlistsJson = JSON.stringify(this.playlists)
    this.localStorageService.set('playlists', playlistsJson)
  }

  private removeFromPlaylists(): void {
    var index = this.playlists.indexOf(this.selectedPlaylist);
    if (index > -1) {
      this.playlists.splice(index, 1)
    }
  }

  private selectSongsIds(): void {
    var length = this.selectedPlaylist.songs.length
    var songs = this.selectedPlaylist.songs;

    for (var i = 0; i != length; i++) {
      this.selectedPlaylistSongsIds.push(songs[i].id);
    }
  }

  private getIndexById(searchedId: number): number {
    var filtered = this.playlists.filter(playlist => playlist.id === searchedId);
    return this.playlists.indexOf(filtered[0])
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}

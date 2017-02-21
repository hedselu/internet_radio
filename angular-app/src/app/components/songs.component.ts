import { Component }                       from '@angular/core';
import { Angular2TokenService }            from 'angular2-token';
import { FileUploader }                    from 'ng2-file-upload/ng2-file-upload';
import { Song }                            from '../models/song.models';
import { LocalStorageService }             from 'angular-2-local-storage';

const URL = 'http://localhost:3000/songs';

@Component({
  selector: 'songs',
  templateUrl: '../templates/songs.component.html'
})
//TODO
//move data fetching to external services
export class SongsComponent {
  private songs: Song[];
  private headers: any[]
  public uploader: FileUploader;
  public hasBaseDropZoneOver: boolean = false;

  constructor(
    public _tokenService: Angular2TokenService,
    private localStorageService: LocalStorageService
  ) {
    var authData = _tokenService.currentAuthData;
    this.headers = [
      { name: 'access-token', value: authData.accessToken },
      { name: 'client', value: authData.client },
      { name: 'expiry', value: authData.expiry },
      { name: 'token-type', value: authData.tokenType },
      { name: 'uid', value: authData.uid }];

    this.uploader = new FileUploader({ url: URL, headers: this.headers });
  }

  ngOnInit(): void {
    this.getSongsFromStorage();
    if (this.songs == null) {
      this.getSongsFromRemote();
    }

    this.uploader.onSuccessItem = (item:any, response:string, status:number, headers:any) => {
      var song = new Song()
      var parsedResponse = JSON.parse(response)
      Object.assign(song, parsedResponse)
      this.songs.push(song)
      var songsJson = JSON.stringify(this.songs);
      this.localStorageService.set('songs', songsJson);
    }
  }

  public fileOverBase(e: any): void {
    this.hasBaseDropZoneOver = e;
  }

  getSongsFromStorage(): void {
    var songsString = this.localStorageService.get('songs');
    if (typeof songsString === 'string') {
      var songsJson = JSON.parse(songsString);
      this.songs = songsJson as Song[];
    }
  }

  getSongsFromRemote(): void {
    this._tokenService.get('songs')
      .map(res => res.json() as Song[])
      .subscribe(
      songs => {
        this.songs = songs as Song[];
        var songsJson = JSON.stringify(this.songs);
        console.log(this.songs)
        this.localStorageService.set('songs', songsJson);
      },
      error => this.handleError(error)
      );
  }

  destroy(id: number): void {
    this._tokenService.delete('songs/' + id);
    this.songs = this.songs.filter(song => song.id !== id);
    var songsJson = JSON.stringify(this.songs);
    this.localStorageService.set('songs', songsJson);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}

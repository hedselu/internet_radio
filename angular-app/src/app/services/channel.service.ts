import { Injectable }       from '@angular/core';
import { Headers, Http }    from '@angular/http';
import { Channel }          from '../models/channel.models'

import 'rxjs/add/operator/toPromise';

@Injectable()
export class ChannelService {
    private headers = new Headers({'Content-Type': 'application/json', 'Accept': 'application/json'});
    private createChannelUrl = 'http://localhost:3000/channels';

    constructor(
        private http: Http
    ) {}

    getAll(): Promise<Channel[]>{
        return this.http.get(this.createChannelUrl, { headers: this.headers })
            .toPromise()
            .then(response => response.json() as Channel[])
            .catch(this.handleError)
    }

    private handleError(error: any): Promise<any> {
        return Promise.reject(error.message || error);
    }
}

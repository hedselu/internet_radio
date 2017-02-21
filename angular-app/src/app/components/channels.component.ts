import { Component } from '@angular/core';
import { ChannelService }   from '../services/channel.service';
import { Channel }          from '../models/channel.models';

@Component({
    selector: 'channels',
    templateUrl: '../templates/channels.component.html'
})

export class ChannelsComponent{
    private channels: Promise<Channel[]>;
    private term: string;
    private selectedChannel: Channel;
    private audio: any;

    constructor(private channelService: ChannelService){}

    ngOnInit(): void {
        this.term = '';
        this.channels = this.channelService.getAll();
    }

    play(): void {
        this.audio = new Audio('http://localhost:8000/' + this.selectedChannel.name);
        this.audio.onerror = (error: any) => {
          console.log(error)
        }
        this.audio.play();
    }

    stop(): void {
        this.audio.pause();
        this.audio.currentTime = 0;
    }

    select(channel: Channel): void {
        this.selectedChannel = channel;
    }
}

package Plugins::NowPlayingShare::Plugin;

use strict;
use warnings;
use base qw(Slim::Plugin::Base);

use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Slim::Web::Pages;
use Slim::Web::HTTP;

my $log = Slim::Utils::Log->addLogCategory({
    'category'     => 'plugin.nowplayingshare',
    'defaultLevel' => 'INFO',
    'description'  => 'Now Playing Share',
});

my $prefs = preferences('plugin.nowplayingshare');

sub initPlugin {
    my $class = shift;
    $class->SUPER::initPlugin(@_);

    Slim::Web::Pages->addPageFunction(
        'plugins/NowPlayingShare/index.html', \&handleWebIndex
    );
    Slim::Web::Pages->addPageLinks(
        'plugins', { 'PLUGIN_NOW_PLAYING_SHARE' => 'plugins/NowPlayingShare/index.html' }
    );
    # _svg.png for Extras menu icon (Material Skin reads the .svg alongside it)
    Slim::Web::Pages->addPageLinks(
        'icons', { 'PLUGIN_NOW_PLAYING_SHARE' => 'plugins/NowPlayingShare/html/images/NowPlayingShareIcon_svg.png' }
    );

    $log->info('NowPlayingShare plugin initialised');
}

sub webPages {
    my $class = shift;
    if (Slim::Utils::PluginManager->isEnabled('Plugins::NowPlayingShare::Plugin')) {
        Slim::Web::Pages->addPageFunction(
            'plugins/NowPlayingShare/index.html', \&handleWebIndex
        );
        Slim::Web::Pages->addPageLinks(
            'plugins', { 'PLUGIN_NOW_PLAYING_SHARE' => 'plugins/NowPlayingShare/index.html' }
        );
        # _svg.png for Extras menu icon (Material Skin reads the .svg alongside it)
        Slim::Web::Pages->addPageLinks(
            'icons', { 'PLUGIN_NOW_PLAYING_SHARE' => 'plugins/NowPlayingShare/html/images/NowPlayingShareIcon_svg.png' }
        );
    } else {
        Slim::Web::Pages->addPageLinks('plugins', { 'PLUGIN_NOW_PLAYING_SHARE' => undef });
        Slim::Web::Pages->addPageLinks('icons',   { 'PLUGIN_NOW_PLAYING_SHARE' => undef });
    }
}

sub handleWebIndex {
    my ($client, $params) = @_;
    return Slim::Web::HTTP::filltemplatefile('plugins/NowPlayingShare/index.html', $params);
}

sub getDisplayName { 'PLUGIN_NOW_PLAYING_SHARE' }
sub playerMenu     { undef }
sub getFunctions   { return {}; }
sub enabled        { return 1; }

1;

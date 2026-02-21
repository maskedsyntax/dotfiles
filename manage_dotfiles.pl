#!/usr/bin/env perl
use strict;
use warnings;
use File::Spec;
use File::Basename;
use Cwd 'abs_path';

# Get the absolute path to the dotfiles directory
my $dotfiles_dir = dirname(abs_path($0));
my $home_dir = $ENV{HOME};

sub create_symlink {
    my ($source, $target) = @_;

    # Ensure target parent directory exists
    my $target_parent = dirname($target);
    unless (-d $target_parent) {
        print "Creating directory: $target_parent
";
        system("mkdir", "-p", $target_parent);
    }

    # Remove existing file or symlink
    if (-l $target || -e $target) {
        print "Removing existing: $target
";
        system("rm", "-rf", $target);
    }

    print "Linking: $source -> $target
";
    if (symlink($source, $target)) {
        return 1;
    } else {
        warn "Failed to link $source to $target: $!
";
        return 0;
    }
}

# 1. Handle 'home/' directory (files go directly to $HOME)
my $home_src = File::Spec->catdir($dotfiles_dir, 'home');
if (-d $home_src) {
    print "
--- Deploying HOME dotfiles ---
";
    opendir(my $dh, $home_src) or die "Could not open $home_src: $!";
    while (my $file = readdir($dh)) {
        next if $file =~ /^\.\.?$/; # Skip . and ..
        my $source = File::Spec->catfile($home_src, $file);
        my $target = File::Spec->catfile($home_dir, $file);
        create_symlink($source, $target);
    }
    closedir($dh);
}

# 2. Handle 'config/' directory (folders go to $HOME/.config/)
my $config_src = File::Spec->catdir($dotfiles_dir, 'config');
if (-d $config_src) {
    print "
--- Deploying .config folders ---
";
    opendir(my $dh, $config_src) or die "Could not open $config_src: $!";
    while (my $folder = readdir($dh)) {
        next if $folder =~ /^\.\.?$/;
        my $source = File::Spec->catdir($config_src, $folder);
        my $target = File::Spec->catdir($home_dir, '.config', $folder);
        create_symlink($source, $target);
    }
    closedir($dh);
}

# 3. Handle 'bin/' directory (scripts go to $HOME/.local/bin/)
my $bin_src = File::Spec->catdir($dotfiles_dir, 'bin');
if (-d $bin_src) {
    print "
--- Deploying scripts to .local/bin ---
";
    opendir(my $dh, $bin_src) or die "Could not open $bin_src: $!";
    while (my $item = readdir($dh)) {
        next if $item =~ /^\.\.?$/;
        my $source = File::Spec->catfile($bin_src, $item);
        my $target = File::Spec->catfile($home_dir, '.local', 'bin', $item);
        create_symlink($source, $target);
    }
    closedir($dh);
}

print "
Done! Dotfiles managed.
";

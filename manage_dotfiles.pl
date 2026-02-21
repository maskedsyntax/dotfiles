#!/usr/bin/env perl
use strict;
use warnings;
use File::Spec;
use File::Basename;
use Cwd 'abs_path';
use Getopt::Long;

# Get the absolute path to the dotfiles directory
my $dotfiles_dir = dirname(abs_path($0));
my $home_dir = $ENV{HOME};

# Command line options
my $install = 0;
my $push    = 0;
my $message = "Sync dotfiles: " . scalar(localtime());

GetOptions(
    'install'   => \$install,
    'push'      => \$push,
    'message=s' => \$message,
) or die "Usage: $0 [--install] [--push] [--message 'commit message']\n";

# Default to install if no options provided
$install = 1 if !$install && !$push;

sub create_symlink {
    my ($source, $target) = @_;

    # Ensure target parent directory exists
    my $target_parent = dirname($target);
    unless (-d $target_parent) {
        print "Creating directory: $target_parent\n";
        system("mkdir", "-p", $target_parent);
    }

    # Remove existing file or symlink
    if (-l $target || -e $target) {
        # Don't delete if it's already a symlink pointing to the right place
        if (-l $target && readlink($target) eq $source) {
            print "Link already exists: $target\n";
            return 1;
        }
        print "Removing existing: $target\n";
        system("rm", "-rf", $target);
    }

    print "Linking: $source -> $target\n";
    if (symlink($source, $target)) {
        return 1;
    } else {
        warn "Failed to link $source to $target: $!\n";
        return 0;
    }
}

sub deploy_links {
    # 1. Handle 'home/' directory
    my $home_src = File::Spec->catdir($dotfiles_dir, 'home');
    if (-d $home_src) {
        print "\n--- Deploying HOME dotfiles ---\n";
        opendir(my $dh, $home_src) or die "Could not open $home_src: $!";
        while (my $file = readdir($dh)) {
            next if $file =~ /^\.\.?$/;
            create_symlink(File::Spec->catfile($home_src, $file), File::Spec->catfile($home_dir, $file));
        }
        closedir($dh);
    }

    # 2. Handle 'config/' directory
    my $config_src = File::Spec->catdir($dotfiles_dir, 'config');
    if (-d $config_src) {
        print "\n--- Deploying .config folders ---\n";
        opendir(my $dh, $config_src) or die "Could not open $config_src: $!";
        while (my $folder = readdir($dh)) {
            next if $folder =~ /^\.\.?$/;
            create_symlink(File::Spec->catdir($config_src, $folder), File::Spec->catdir($home_dir, '.config', $folder));
        }
        closedir($dh);
    }

    # 3. Handle 'bin/' directory
    my $bin_src = File::Spec->catdir($dotfiles_dir, 'bin');
    if (-d $bin_src) {
        print "\n--- Deploying scripts to .local/bin ---\n";
        opendir(my $dh, $bin_src) or die "Could not open $bin_src: $!";
        while (my $item = readdir($dh)) {
            next if $item =~ /^\.\.?$/;
            create_symlink(File::Spec->catfile($bin_src, $item), File::Spec->catfile($home_dir, '.local', 'bin', $item));
        }
        closedir($dh);
    }
}

sub push_changes {
    print "\n--- Syncing changes to GitHub ---\n";
    chdir($dotfiles_dir) or die "Could not change to $dotfiles_dir: $!";
    
    # Pull latest changes first to avoid conflicts
    print "Pulling latest changes...\n";
    system("git pull --rebase origin master");
    
    # Add, commit and push
    print "Adding changes...\n";
    system("git add .");
    
    # Check if there are changes to commit
    my $status = `git status --porcelain`;
    if ($status) {
        print "Committing changes: $message\n";
        system("git", "commit", "-m", $message);
        print "Pushing to GitHub...\n";
        system("git push origin master");
    } else {
        print "No local changes to push.\n";
    }
}

# Execute requested actions
deploy_links() if $install;
push_changes() if $push;

print "\nOperation completed successfully.\n";

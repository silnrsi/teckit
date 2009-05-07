package InstallPar;

$unzip_cmd = 'unzip $dist -d $path';
$unzip_cmd = '7za x $dist -o$path -r' if ($^O eq 'MSWin32');

$DEBUG = 0;

use Config;
use File::Path;
use File::Spec;
use File::Temp;
use Cwd;

sub install_all
{
    my (@jobs) = @_;
    my ($job, $module, $version, $file);

    foreach $job (@jobs)
    {
        next unless test(@$job);
        unless ($file = find_file(@$job))
        {
            warn "Can't find a PAR file for $job->[0] v$job->[1]";
            next;
        }
        install($job->[0], $file);
    }
}

sub test
{
    my ($module, $version) = @_;

    if (eval "require $module")     # installed
    {
        return 0 if (${"${module}::VERSION"} >= $version);
    }
    return 1;
}

sub find_file
{
    my ($module, $version) = @_;
    my ($fbase) = $module;
    my (@res, $res);

    $fbase =~ s|::|-|og;
    $fbase .= "-$version-$Config::Config{archname}";
    @res = glob("$fbase*.par");
    $res = (grep {$_ eq "$fbase-$Config::Config{version}.par"} @res)[0];
    return $res if $res;
    return $res[0] if ($res[0]);

# try non binary modules
    $fbase = $module;
    $fbase =~ s/::/-/og;
    @res = glob("$fbase-$version-noarch*.par");
    $res = (grep {$_ eq "$fbase-$Config::Config{version}.par"} @res)[0];
    return $res if $res;
    return $res[0] if ($res[0]);
}

sub install
{
    my ($module, $fname) = @_;
    my ($cwd) = getcwd;
    my ($dist, $tmpdir) = unzip_to_tmpdir($fname, 'blib');
    my ($name) = $module;
    my ($rv);

    $name =~ s|::|/|og;

    if (-d 'script')
    {
        require ExtUtils::MY;
        foreach my $file (glob("script/*"))
        {
            next unless -T $file;
            if ($DEBUG)
            { print STDERR "Scripting $file\n"; }
            elsif ($^O eq 'MSWin32' && ! -f "$file.bat" && $file !~m/\.bat$/oi)
            { system("pl2bat", $file); }
            else
            { ExtUtils::MY->fixin($file); }
            chmod(0555, $file);
        }
    }
    chdir('..');

    $name =~ s{::|-}{/}g;
    require ExtUtils::Install;

    if ($DEBUG)
    { print STDERR "Installing $name from $fname in $tmpdir\n"; }
    else
    { $rv = ExtUtils::Install::install_default($name); }

#    elsif ($action eq 'uninstall') {
#    require Config;
#    $rv = ExtUtils::Install::uninstall(
#        "$Config::Config{installsitearch}/auto/$name/.packlist"
#    );
#    }

    chdir($cwd);
    File::Path::rmtree([$tmpdir]);
    return $rv;
}

sub uninstall
{
    $rv = ExtUtils::Install::uninstall("$Config::Config{installsitearch}/auto/$name/.packlist");
}

sub unzip_to_tmpdir
{
    my ($dist, $subdir) = @_;

    $dist = File::Spec->rel2abs($dist);
    my $tmpdir = File::Temp::mkdtemp(File::Spec->catdir(File::Spec->tmpdir, "parXXXXX")) or die $!;
    $tmpdir = File::Spec->catdir($tmpdir, $subdir) if defined $subdir;
    unzip($dist, $tmpdir) || die "Can't unzip $dist to $tmpdir";
    chdir $tmpdir;
    return ($dist, $tmpdir);
}

sub unzip
{
    my ($dist, $path) = @_;
    my ($failed);
    return 0 unless -f $dist;
    $path ||= File::Spec->curdir;

    if (eval { require Archive::Zip; 1 })
    {
        my (@members, $file, $m);
        my $zip = Archive::Zip->new;
        $SIG{__WARN__} = sub { print STDERR $_[0] unless $_[0] =~ /\bstat\b/ };
        unless ($zip->read($dist) == Archive::Zip::AZ_OK())
        {
            $failed = 1;
            last;
        }
        
        @members = $zip->members();
        foreach $m (@members)
        {
            $file = "$path/" . $m->fileName();

            $file = Archive::Zip::_asLocalName($file);
            next if ($^O eq "MSWin32" && $file =~ m/::/o);
            if ($m->extractToFileNamed($file) != AZ_OK)
            {
                $failed = 1;
                last;
            }
        }
        return 1;
#           $zip->extractTree('', "$path/") == Archive::Zip::AZ_OK());  # but with filtering
    }
    else
    { $failed = 1; }
# try using a system command
    if ($failed && $unzip_cmd)
    {
        my ($cmd) = $unzip_cmd;
        $cmd =~ s/\$([\w+])/$$1/oge;
        print STDERR "$cmd\n" if ($DEBUG);
        return 1 unless system($cmd);
    }
    return 0;
}

1;

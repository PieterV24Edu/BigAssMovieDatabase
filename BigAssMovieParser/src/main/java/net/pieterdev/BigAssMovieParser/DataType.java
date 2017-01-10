package net.pieterdev.BigAssMovieParser;

import net.pieterdev.BigAssMovieParser.Parsers.ActorParser;
import net.pieterdev.BigAssMovieParser.Parsers.MPAAParser;
import net.pieterdev.BigAssMovieParser.Parsers.MovieParser;
import net.pieterdev.BigAssMovieParser.Parsers.RuntimeParser;
import net.pieterdev.BigAssMovieParser.Parsers.GenreParser;
import net.pieterdev.BigAssMovieParser.Parsers.ParserBase;
import net.pieterdev.BigAssMovieParser.Parsers.WriterParser;

public enum DataType {
    MOVIES,
<<<<<<< HEAD
    GERNES,
    RUNTIMES;

    MovieParser movieParser = new MovieParser();
    GenreParser genreParser = new GenreParser();
    RuntimeParser runtimeParser = new RuntimeParser();
=======
    ACTORS,
    WRITERS,
    MPAA;

    MovieParser movieParser = new MovieParser();
    WriterParser writerParser = new WriterParser();
    MPAAParser mpaaParser = new MPAAParser();
    ActorParser actorParser = new ActorParser();

>>>>>>> master
    public ParserBase getParser()
    {
        switch (this)
        {
            case ACTORS:
                return actorParser;
            case MOVIES:
                return movieParser;
<<<<<<< HEAD
            case GERNES:
                return genreParser;
            case RUNTIMES:
                return runtimeParser;
=======
            case WRITERS:
                return writerParser;
            case MPAA:
                return mpaaParser;
>>>>>>> master
            default:
                return null;
        }
    }
}
